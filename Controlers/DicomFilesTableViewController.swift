import SwiftUI

// Window/Level preset in Hounsfield Units (CT)
struct WLPreset: Identifiable {
    let id = UUID()
    let naam: String                    // vaste sleutel (niet vertaald)
    let titel: LocalizedStringResource  // getoonde naam
    let icoon: String
    let center: Double   // HU
    let width: Double    // HU

    static let alle: [WLPreset] = [
        WLPreset(naam: "Abdomen",  titel: "Abdomen",  icoon: "figure.core.training", center: 40,   width: 400),
        WLPreset(naam: "Long",     titel: "Long",     icoon: "lungs.fill",           center: -600, width: 1500),
        WLPreset(naam: "Bot",      titel: "Bot",      icoon: "figure.stand",         center: 300,  width: 1500),
        WLPreset(naam: "Hersenen", titel: "Hersenen", icoon: "brain.fill",           center: 40,   width: 80),
    ]
}

struct ViewerView: View {
    let parsed: ParsedDICOM
    var titel: String = ""
    /// true op iPad: de viewer staat naast de lijst, dus geen sluitknop.
    var ingebed: Bool = false
    @Environment(\.dismiss) private var dismiss

    @State private var frameIdx   = 0
    @State private var isPlaying  = false
    @State private var fps: Double = 10
    @State private var cineTimer: Timer?
    @State private var showOverlay = true
    @State private var inverted = false
    @State private var showInfo = false

    // Meten (#4): punten in beeldpixels (x = kolom, y = rij)
    @State private var meten = false
    @State private var meetPunten: [CGPoint] = []

    @State private var scale: CGFloat     = 1
    @State private var lastScale: CGFloat = 1
    @State private var offset: CGSize     = .zero
    @State private var lastOffset: CGSize = .zero

    // Window/Level presets
    @State private var presetFrames: [CGImage]? = nil   // nil = origineel venster
    @State private var presetNaam = "Auto"
    @State private var huidigWC: Double = 0
    @State private var huidigWW: Double = 0
    @State private var isRendering = false

    // Frame-export
    private struct ExportItem: Identifiable { let id = UUID(); let url: URL }
    @State private var exportItem: ExportItem?

    private var frames: [CGImage] { presetFrames ?? parsed.frames }

    private var frame: CGImage? {
        guard !frames.isEmpty else { return nil }
        return frames[min(frameIdx, frames.count - 1)]
    }

    private var isCine: Bool { frames.count > 1 }

    private var kopTitel: String {
        if !titel.isEmpty { return titel }
        return parsed.modality.isEmpty ? String(localized: "Scan") : parsed.modality
    }

    private var kopDetails: String {
        var delen: [String] = []
        if !parsed.modality.isEmpty { delen.append(parsed.modality) }
        delen.append("\(parsed.columns) × \(parsed.rows)")
        if isCine { delen.append(String(localized: "\(frames.count) beelden")) }
        return delen.joined(separator: " · ")
    }

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            if let cgImg = frame {
                Image(uiImage: UIImage(cgImage: cgImg))
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .modifier(InvertIf(on: inverted))
                    .overlay { meetLaag }
                    .scaleEffect(scale)
                    .offset(offset)
                    .gesture(pinchGesture)
                    .gesture(dragGesture)
                    .onTapGesture(count: 2) { resetTransform() }
                    .onTapGesture(count: 1) {
                        withAnimation(.easeInOut(duration: 0.2)) { showOverlay.toggle() }
                    }
                    .accessibilityLabel("Medisch beeld")
            } else {
                VStack(spacing: 12) {
                    Image(systemName: "exclamationmark.triangle")
                        .font(.system(size: 36))
                        .foregroundColor(Med.warn)
                    Text("Geen beelddata in dit bestand")
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(Med.textSec)
                }
            }

            if showOverlay {
                VStack(spacing: 0) {
                    topBar
                    Spacer()
                    bedieningsPaneel
                }
                .transition(.opacity)
            }
        }
        .preferredColorScheme(.dark)
        .onAppear {
            #if DEBUG
            // Testhulp: `-meetTest YES` zet meten aan met twee vaste punten (alleen debug-builds).
            if UserDefaults.standard.bool(forKey: "meetTest") {
                meten = true
                meetPunten = [CGPoint(x: 150, y: 150), CGPoint(x: 350, y: 300)]
            }
            #endif
        }
        .onDisappear { stopCine() }
        .sheet(item: $exportItem) { item in
            ShareSheet(url: item.url)
        }
        .sheet(isPresented: $showInfo) {
            infoSheet
        }
    }

    // MARK: Top bar

    private var topBar: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 10) {
                if !ingebed {
                    Button {
                        stopCine(); dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(Med.textPri)
                            .medGlassCircle()
                    }
                    .accessibilityLabel("Sluiten")
                }

                VStack(alignment: .leading, spacing: 1) {
                    Text(kopTitel)
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(Med.textPri)
                        .lineLimit(1)
                    Text(kopDetails)
                        .font(.system(size: 11))
                        .foregroundColor(Color(hex: "AEB9CB"))
                        .lineLimit(1)
                }
                .padding(.horizontal, 16)
                .frame(maxWidth: .infinity, minHeight: 44, alignment: .leading)
                .medGlass(cornerRadius: 22)

                Button { showInfo = true } label: {
                    Image(systemName: "info")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(Med.textPri)
                        .medGlassCircle()
                }
                .accessibilityLabel("Scangegevens en exporteren")
            }

            if parsed.windowWidth > 0 {
                HStack(spacing: 8) {
                    wlChip("W", presetFrames == nil ? parsed.windowWidth : huidigWW)
                    wlChip("L", presetFrames == nil ? parsed.windowCenter : huidigWC)
                    if inverted {
                        Text("Omgekeerd")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(Med.textPri)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 6)
                            .medGlass(cornerRadius: 12)
                    }
                }
            }

            if meten { meetBanner }
        }
        .padding(.horizontal, 16)
        .padding(.top, 8)
    }

    private func wlChip(_ label: String, _ waarde: Double) -> some View {
        HStack(spacing: 4) {
            Text(label).foregroundColor(Med.textPri)
            Text(String(format: "%.0f", waarde)).foregroundColor(Med.accentText)
        }
        .font(.system(size: 12, weight: .semibold).monospacedDigit())
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .medGlass(cornerRadius: 12)
        .accessibilityElement(children: .combine)
        .accessibilityLabel(label == "W" ? "Window \(Int(waarde))" : "Level \(Int(waarde))")
    }

    // MARK: Bedieningspaneel (glas, onderin)

    private var bedieningsPaneel: some View {
        VStack(spacing: 14) {
            if parsed.kanHervensteren {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        presetChip(String(localized: "Auto"), actief: presetFrames == nil) {
                            presetFrames = nil; presetNaam = "Auto"
                        }
                        ForEach(WLPreset.alle) { p in
                            presetChip(String(localized: p.titel), actief: presetNaam == p.naam && presetFrames != nil) {
                                pasPresetToe(p)
                            }
                        }
                        if isRendering {
                            ProgressView().tint(Med.accentText).padding(.leading, 4)
                        }
                    }
                }
            }

            if isCine {
                VStack(spacing: 4) {
                    Slider(
                        value: Binding(
                            get: { Double(frameIdx) },
                            set: { frameIdx = Int($0.rounded()) }
                        ),
                        in: 0...Double(frames.count - 1),
                        step: 1
                    )
                    .tint(Med.accent)
                    .accessibilityLabel("Beeld")
                    HStack {
                        Text("Beeld \(frameIdx + 1) van \(frames.count)")
                        Spacer()
                        Text("\(Int(fps)) bps")
                    }
                    .font(.system(size: 12).monospacedDigit())
                    .foregroundColor(Color(hex: "AEB9CB"))
                }
            }

            HStack {
                Button { inverted.toggle() } label: {
                    Image(systemName: "circle.lefthalf.filled")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(inverted ? Med.onAccent : Med.textPri)
                        .frame(width: 44, height: 44)
                        .background(inverted ? Med.accent : Color.white.opacity(0.10), in: Circle())
                }
                .accessibilityLabel("Contrast omkeren")

                Button {
                    meten.toggle()
                    if !meten { meetPunten = [] }
                } label: {
                    Image(systemName: "ruler")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(meten ? Med.onAccent : Med.textPri)
                        .frame(width: 44, height: 44)
                        .background(meten ? Med.accent : Color.white.opacity(0.10), in: Circle())
                }
                .accessibilityLabel(meten ? "Meten uitzetten" : "Afstand meten")

                Spacer()

                if isCine {
                    HStack(spacing: 14) {
                        rondeKnop("backward.frame.fill", label: "Vorig beeld") {
                            stopCine(); frameIdx = max(0, frameIdx - 1)
                        }
                        Button { isPlaying ? stopCine() : startCine() } label: {
                            Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                                .font(.system(size: 24, weight: .semibold))
                                .foregroundColor(Med.onAccent)
                                .offset(x: isPlaying ? 0 : 2)
                                .frame(width: 64, height: 64)
                                .background(Med.accent, in: Circle())
                        }
                        .accessibilityLabel(isPlaying ? "Pauzeren" : "Afspelen")
                        rondeKnop("forward.frame.fill", label: "Volgend beeld") {
                            stopCine(); frameIdx = min(frames.count - 1, frameIdx + 1)
                        }
                    }

                    Spacer()

                    Menu {
                        ForEach([5, 10, 15, 24, 30], id: \.self) { f in
                            Button("\(f) beelden per seconde") {
                                fps = Double(f)
                                if isPlaying { stopCine(); startCine() }
                            }
                        }
                    } label: {
                        Text("\(Int(fps))")
                            .font(.system(size: 14, weight: .bold).monospacedDigit())
                            .foregroundColor(Med.textPri)
                            .frame(width: 44, height: 44)
                            .background(Color.white.opacity(0.10), in: Circle())
                    }
                    .accessibilityLabel("Snelheid")
                } else {
                    Text("Knijp om te zoomen · dubbeltik om terug te zetten")
                        .font(.system(size: 12))
                        .foregroundColor(Color(hex: "AEB9CB"))
                    Spacer()
                }
            }
        }
        .padding(14)
        .padding(.bottom, 2)
        .medGlass(cornerRadius: 30)
        .padding(.horizontal, 12)
        .padding(.bottom, 8)
    }

    private func presetChip(_ naam: String, actief: Bool, actie: @escaping () -> Void) -> some View {
        Button(action: actie) {
            Text(naam)
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(actief ? Color(hex: "0A0E15") : Color(hex: "DCE3EE"))
                .padding(.horizontal, 14)
                .frame(height: 36)
                .background(actief ? Med.textPri : Color.clear, in: Capsule())
                .overlay(Capsule().stroke(actief ? Color.clear : Color.white.opacity(0.18), lineWidth: 1))
        }
        .disabled(isRendering)
    }

    private func rondeKnop(_ icoon: String, label: String, actie: @escaping () -> Void) -> some View {
        Button(action: actie) {
            Image(systemName: icoon)
                .font(.system(size: 18, weight: .medium))
                .foregroundColor(Med.textPri)
                .frame(width: 48, height: 48)
                .background(Color.white.opacity(0.10), in: Circle())
        }
        .accessibilityLabel(label)
    }

    // MARK: Meten (#4)

    /// Tekenlaag over het beeld; vangt tikken alleen op als meten aan staat.
    private var meetLaag: some View {
        GeometryReader { geo in
            let sx = geo.size.width / CGFloat(max(parsed.columns, 1))
            let sy = geo.size.height / CGFloat(max(parsed.rows, 1))
            let schermPunten = meetPunten.map { CGPoint(x: $0.x * sx, y: $0.y * sy) }
            let dikte = 2 / max(scale, 1)
            let straal = 7 / max(scale, 1)

            ZStack(alignment: .topLeading) {
                if meten {
                    Color.clear
                        .contentShape(Rectangle())
                        .gesture(SpatialTapGesture().onEnded { v in
                            let p = CGPoint(x: min(max(v.location.x / sx, 0), CGFloat(parsed.columns)),
                                            y: min(max(v.location.y / sy, 0), CGFloat(parsed.rows)))
                            meetPunten = meetPunten.count >= 2 ? [p] : meetPunten + [p]
                        })
                }
                if schermPunten.count == 2 {
                    Path { pad in
                        pad.move(to: schermPunten[0])
                        pad.addLine(to: schermPunten[1])
                    }
                    .stroke(Color(hex: "FFD166"), lineWidth: dikte)
                }
                ForEach(Array(schermPunten.enumerated()), id: \.offset) { _, p in
                    Circle()
                        .stroke(Color(hex: "FFD166"), lineWidth: dikte)
                        .background(Circle().fill(Color.black.opacity(0.35)))
                        .frame(width: straal * 2, height: straal * 2)
                        .position(p)
                }
                if schermPunten.count == 2, let tekst = afstandTekst {
                    Text(tekst)
                        .font(.system(size: 13, weight: .bold).monospacedDigit())
                        .foregroundColor(.black)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color(hex: "FFD166"), in: Capsule())
                        .scaleEffect(1 / max(scale, 1))
                        .position(x: (schermPunten[0].x + schermPunten[1].x) / 2,
                                  y: (schermPunten[0].y + schermPunten[1].y) / 2 - 18 / max(scale, 1))
                        .allowsHitTesting(false)
                }
            }
        }
        .allowsHitTesting(meten)
    }

    /// Afstand tussen de twee punten: in mm als de pixelafstand bekend is, anders in pixels.
    private var afstandTekst: String? {
        guard meetPunten.count == 2 else { return nil }
        let dx = Double(meetPunten[1].x - meetPunten[0].x)
        let dy = Double(meetPunten[1].y - meetPunten[0].y)
        if let ps = parsed.pixelSpacing {
            let mm = ((dx * ps.kolom) * (dx * ps.kolom) + (dy * ps.rij) * (dy * ps.rij)).squareRoot()
            return mm.formatted(.number.precision(.fractionLength(1))) + " mm"
        }
        let px = (dx * dx + dy * dy).squareRoot()
        return px.formatted(.number.precision(.fractionLength(0))) + " px"
    }

    private var meetBanner: some View {
        HStack(spacing: 10) {
            Image(systemName: "ruler")
                .foregroundColor(Color(hex: "FFD166"))
            Text(meetUitleg)
                .font(.system(size: 13))
                .foregroundColor(Med.textPri)
                .fixedSize(horizontal: false, vertical: true)
            Spacer(minLength: 0)
            if !meetPunten.isEmpty {
                Button("Wis") { meetPunten = [] }
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(Med.accentText)
            }
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 10)
        .medGlass(cornerRadius: 18)
    }

    private var meetUitleg: String {
        if meetPunten.count < 2 {
            return meetPunten.isEmpty ? String(localized: "Tik op het beginpunt") : String(localized: "Tik op het eindpunt")
        }
        guard let ps = parsed.pixelSpacing else {
            return String(localized: "Geen pixelafstand in dit bestand, dus afstand in pixels")
        }
        return ps.opDetector
            ? String(localized: "Gemeten op de detector; in het lichaam is het iets kleiner")
            : String(localized: "Afstand volgens de pixelafstand in het bestand")
    }

    // MARK: Info-sheet (gegevens + export)

    private var infoSheet: some View {
        NavigationStack {
            List {
                Section("Scan") {
                    if !parsed.patientName.isEmpty {
                        LabeledContent("Patiënt", value: parsed.patientName)
                    }
                    if !parsed.modality.isEmpty {
                        LabeledContent("Modaliteit", value: parsed.modality)
                    }
                    LabeledContent("Afmeting", value: "\(parsed.columns) × \(parsed.rows)")
                    LabeledContent("Beelden", value: "\(frames.count)")
                    if let ps = parsed.pixelSpacing {
                        LabeledContent(ps.opDetector ? "Pixelafstand (detector)" : "Pixelafstand",
                                       value: ps.kolom.formatted(.number.precision(.fractionLength(3))) + " mm")
                    }
                    if parsed.windowWidth > 0 {
                        LabeledContent("Window / Level",
                                       value: String(format: "%.0f / %.0f",
                                                     presetFrames == nil ? parsed.windowWidth : huidigWW,
                                                     presetFrames == nil ? parsed.windowCenter : huidigWC))
                    }
                }
                if frame != nil {
                    Section {
                        Button {
                            showInfo = false
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) { exporteerFrame(als: "PNG") }
                        } label: {
                            Label("Dit beeld exporteren als PNG", systemImage: "photo")
                        }
                        Button {
                            showInfo = false
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) { exporteerFrame(als: "JPEG") }
                        } label: {
                            Label("Dit beeld exporteren als JPEG", systemImage: "photo.fill")
                        }
                    } header: {
                        Text("Exporteren")
                    } footer: {
                        Text("Het beeld wordt geëxporteerd met het gekozen venster (zonder omkeren).")
                    }
                }
            }
            .navigationTitle(kopTitel)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Klaar") { showInfo = false }
                }
            }
        }
        .tint(Med.accentText)
        .presentationDetents([.medium, .large])
        .preferredColorScheme(.dark)
    }

    // MARK: Frame-export

    /// Exporteert het huidige frame (met actieve preset-venstering) als
    /// PNG of JPEG via het deelvenster.
    private func exporteerFrame(als formaat: String) {
        guard let cg = frame else { return }
        let img = UIImage(cgImage: cg)
        let data: Data?
        let ext: String
        if formaat == "PNG" {
            data = img.pngData(); ext = "png"
        } else {
            data = img.jpegData(compressionQuality: 0.92); ext = "jpg"
        }
        guard let d = data else { return }
        let naam = "DICOM-frame-\(frameIdx + 1).\(ext)"
        let url = FileManager.default.temporaryDirectory.appendingPathComponent(naam)
        do {
            try d.write(to: url)
            exportItem = ExportItem(url: url)
        } catch { /* tijdelijke map niet beschrijfbaar — stil falen */ }
    }

    // MARK: Window/Level presets

    private func pasPresetToe(_ p: WLPreset) {
        isRendering = true
        let (rawC, rawW) = parsed.huNaarRaw(center: p.center, width: p.width)
        Task.detached(priority: .userInitiated) {
            let nieuw = parsed.render(center: rawC, width: rawW)
            await MainActor.run {
                isRendering = false
                guard !nieuw.isEmpty else { return }
                presetFrames = p.naam == "Auto" ? nil : nieuw
                presetNaam   = p.naam
                huidigWC     = p.center
                huidigWW     = p.width
            }
        }
    }

    // MARK: Cine engine

    private func startCine() {
        isPlaying = true
        cineTimer = Timer.scheduledTimer(withTimeInterval: 1.0 / fps, repeats: true) { _ in
            frameIdx = (frameIdx + 1) % frames.count
        }
    }

    private func stopCine() {
        isPlaying = false
        cineTimer?.invalidate()
        cineTimer = nil
    }

    // MARK: Gestures

    private var pinchGesture: some Gesture {
        MagnificationGesture()
            .onChanged { v in scale = max(0.5, min(8, lastScale * v)) }
            .onEnded   { _ in lastScale = scale }
    }

    private var dragGesture: some Gesture {
        DragGesture()
            .onChanged { v in
                offset = CGSize(
                    width:  lastOffset.width  + v.translation.width,
                    height: lastOffset.height + v.translation.height
                )
            }
            .onEnded { _ in lastOffset = offset }
    }

    private func resetTransform() {
        withAnimation(.spring()) {
            scale = 1; offset = .zero
            lastScale = 1; lastOffset = .zero
        }
    }
}

/// Keert de grijswaarden om (wit ↔ zwart) als `on` waar is.
private struct InvertIf: ViewModifier {
    let on: Bool
    func body(content: Content) -> some View {
        if on { content.colorInvert() } else { content }
    }
}
