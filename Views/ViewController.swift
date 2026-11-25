import SwiftUI
import UniformTypeIdentifiers

/// Beginscherm (tab "Scans"): eigen scans, laatst geopend en voorbeeldscans.
struct ScansView: View {
    var openLeren: () -> Void = {}

    @StateObject private var store = FileStore.shared
    @StateObject private var thumbs = ThumbCache.shared

    @State private var showImporter  = false
    @State private var selectedInfo: DICOMFileInfo?
    @State private var viewerTitel = ""
    @State private var parsedDICOM: ParsedDICOM?
    @State private var parsedImage: UIImage?
    @State private var showViewer    = false
    @State private var isParsing     = false
    @State private var errorMessage: String?
    @State private var shareFile: DICOMFileInfo?
    @State private var fileToDelete: DICOMFileInfo?
    @State private var seriesToDelete: SeriesGroup?
    @State private var showTipJar = false
    @State private var showTipJarAuto = false
    /// Eén keer per app-start kijken of de fooienpot vanzelf moet verschijnen.
    private static var fooienpotGecontroleerd = false
    @AppStorage("demosHidden") private var demosHidden = false
    @AppStorage("tipJarCoachMarkShown") private var coachMarkShown = false
    @State private var showCoachMark = false
    @State private var viewerID = UUID()
    @Environment(\.horizontalSizeClass) private var sizeClass

    /// iPad (en grote vensters): lijst links, viewer rechts (issue #7).
    private var isSplit: Bool { sizeClass == .regular }

    var body: some View {
        metModifiers(Group {
            if isSplit {
                NavigationSplitView {
                    lijst
                        .toolbar(.hidden, for: .navigationBar)
                        .navigationSplitViewColumnWidth(min: 340, ideal: 380, max: 440)
                } detail: {
                    detail
                }
                .navigationSplitViewStyle(.balanced)
            } else {
                lijst
            }
        })
    }

    private var lijst: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                header

                if store.files.isEmpty {
                    importKaart
                } else {
                    eigenScans
                }

                if !store.bundledDemos.isEmpty {
                    voorbeelden
                }

                lerenTip
            }
            .padding(.horizontal, 20)
            .padding(.top, 8)
            .padding(.bottom, 24)
        }
        .refreshable { store.reload() }
        .background(Med.bg.ignoresSafeArea())
        .medGlow(Med.accent)
    }

    // MARK: Detail (iPad)

    @ViewBuilder
    private var detail: some View {
        if let parsed = parsedDICOM {
            ViewerView(parsed: parsed, titel: viewerTitel, ingebed: true)
                .id(viewerID)
        } else if let img = parsedImage, let file = selectedInfo {
            QuickImageView(image: img, title: file.name, ingebed: true)
                .id(viewerID)
        } else {
            ZStack {
                Med.bg.ignoresSafeArea()
                VStack(spacing: 14) {
                    Image(systemName: "waveform.and.magnifyingglass")
                        .font(.system(size: 44, weight: .light))
                        .foregroundColor(Med.accentText)
                    Text("Kies een scan")
                        .font(.medTitle())
                        .foregroundColor(Med.textPri)
                    Text("Tik links op een scan om hem hier te bekijken.")
                        .font(.system(size: 15))
                        .foregroundColor(Med.textSec)
                }
            }
        }
    }

    /// Alle sheets, alerts en overlays van het Scans-scherm.
    private func metModifiers<V: View>(_ inhoud: V) -> some View {
        inhoud
        .fileImporter(
            isPresented: $showImporter,
            allowedContentTypes: [.data, .item],
            allowsMultipleSelection: false
        ) { result in
            if case .success(let urls) = result, let url = urls.first {
                store.importFile(from: url)
            }
        }
        .fullScreenCover(isPresented: Binding(get: { showViewer && !isSplit }, set: { showViewer = $0 }),
                         onDismiss: { if !isSplit { parsedDICOM = nil; parsedImage = nil } }) {
            if let parsed = parsedDICOM {
                ViewerView(parsed: parsed, titel: viewerTitel)
            } else if let img = parsedImage, let file = selectedInfo {
                QuickImageView(image: img, title: file.name)
            }
        }
        .sheet(item: $shareFile) { file in
            ShareSheet(url: file.url)
        }
        .sheet(isPresented: $showTipJar) {
            TipJarView()
        }
        .background(
            EmptyView().sheet(isPresented: $showTipJarAuto) {
                TipJarView(automatisch: true)
            }
        )
        .overlay {
            if isParsing { loadingOverlay }
        }
        .overlay {
            if showCoachMark {
                TipJarCoachMark(isShowing: $showCoachMark, onDonate: { showTipJar = true })
                    .zIndex(100)
            }
        }
        .onAppear {
            #if DEBUG
            // Testhulp: `-demoOpen <n>` opent direct voorbeeldscan n (alleen debug-builds).
            if UserDefaults.standard.object(forKey: "demoOpen") != nil {
                let n = UserDefaults.standard.integer(forKey: "demoOpen")
                let demos = store.bundledDemos
                if demos.indices.contains(n) { open(demos[n], titel: demoViewerTitel(demos[n])) }
            }
            #endif
            // #11: elke 50e start de fooienpot (niet bij de eerste start: dan is er het hulpje).
            if coachMarkShown, !Self.fooienpotGecontroleerd {
                Self.fooienpotGecontroleerd = true
                if AppStart.toonFooienpot {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { showTipJarAuto = true }
                }
            }
            if !coachMarkShown {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                    withAnimation { showCoachMark = true }
                    coachMarkShown = true
                }
            }
        }
        .alert("Bestand verwijderen?", isPresented: .init(
            get: { fileToDelete != nil },
            set: { if !$0 { fileToDelete = nil } }
        )) {
            Button("Verwijder", role: .destructive) {
                if let f = fileToDelete { store.delete(f) }
                fileToDelete = nil
            }
            Button("Annuleer", role: .cancel) { fileToDelete = nil }
        } message: {
            Text("\(fileToDelete?.name ?? "") wordt permanent verwijderd.")
        }
        .alert("Serie verwijderen?", isPresented: .init(
            get: { seriesToDelete != nil },
            set: { if !$0 { seriesToDelete = nil } }
        )) {
            Button("Verwijder", role: .destructive) {
                if let s = seriesToDelete { s.files.forEach { store.delete($0) } }
                seriesToDelete = nil
            }
            Button("Annuleer", role: .cancel) { seriesToDelete = nil }
        } message: {
            Text("\(seriesToDelete?.description ?? "") — \(seriesToDelete?.files.count ?? 0) bestanden worden permanent verwijderd.")
        }
        .alert("Bestand niet ondersteund", isPresented: .init(
            get: { errorMessage != nil },
            set: { if !$0 { errorMessage = nil } }
        )) {
            Button("OK", role: .cancel) { errorMessage = nil }
        } message: {
            Text(errorMessage ?? "")
        }
    }

    private func isGekozen(_ url: URL) -> Bool {
        isSplit && selectedInfo?.url == url && (parsedDICOM != nil || parsedImage != nil)
    }

    // MARK: Header

    private var ondertitel: String {
        let demos = store.bundledDemos.count
        if store.files.isEmpty { return "\(demos) voorbeeldscans" }
        let n = store.series.isEmpty ? store.files.count : store.series.count
        return n == 1 ? "1 eigen scan" : "\(n) eigen scans"
    }

    private var header: some View {
        MedScreenHeader(title: "Scans", subtitle: ondertitel) {
            HStack(spacing: 10) {
                Button { showTipJar = true } label: {
                    Image(systemName: "heart.fill")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(Med.heart)
                        .medGlassCircle()
                }
                .accessibilityLabel("Fooienpot")
                Button { showImporter = true } label: {
                    Image(systemName: "plus")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(Med.textPri)
                        .medGlassCircle()
                }
                .accessibilityLabel("Scan importeren")
            }
        }
    }

    // MARK: Import (lege staat)

    private var importKaart: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(spacing: 14) {
                Image(systemName: "doc.badge.plus")
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundColor(Med.accentText)
                    .frame(width: 52, height: 52)
                    .background(Med.accent.opacity(0.16), in: RoundedRectangle(cornerRadius: 16))
                VStack(alignment: .leading, spacing: 3) {
                    Text("Eigen scan openen")
                        .font(.system(size: 17, weight: .bold))
                        .foregroundColor(Med.textPri)
                    Text("Uit Bestanden, Mail of AirDrop. Blijft alleen op je toestel.")
                        .font(.system(size: 14))
                        .foregroundColor(Med.textSec)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
            Button { showImporter = true } label: {
                Text("Kies een DICOM-bestand")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(Med.onAccent)
                    .frame(maxWidth: .infinity, minHeight: 50)
                    .background(Med.accent, in: Capsule())
            }
        }
        .padding(20)
        .medCard(cornerRadius: 24)
    }

    // MARK: Eigen scans

    private var eigenScans: some View {
        VStack(alignment: .leading, spacing: 18) {
            if !store.recent.isEmpty {
                sectieKop("Laatst geopend")
                VStack(spacing: 10) {
                    ForEach(store.recent) { file in
                        Button { open(file) } label: {
                            ScanRow(file: file, titel: file.name, thumbs: thumbs, gekozen: isGekozen(file.url))
                        }
                        .buttonStyle(.plain)
                    }
                }
            }

            sectieKop("Mijn scans")
            // Zolang het groeperen nog loopt: platte bestandslijst
            let groepen = store.series.isEmpty
                ? store.files.map { SeriesGroup(id: $0.url.path, description: $0.name, modality: "", files: [$0]) }
                : store.series
            VStack(spacing: 10) {
                ForEach(groepen) { groep in
                    if groep.isSeries {
                        Button { openSeries(groep) } label: {
                            ScanRow(file: groep.files[0], titel: groep.description, thumbs: thumbs,
                                    serie: groep, gekozen: isGekozen(groep.files[0].url))
                        }
                        .buttonStyle(.plain)
                        .contextMenu {
                            Button(role: .destructive) {
                                seriesToDelete = groep
                            } label: {
                                Label("Verwijder serie (\(groep.files.count) bestanden)", systemImage: "trash")
                            }
                        }
                    } else {
                        Button { open(groep.files[0]) } label: {
                            ScanRow(file: groep.files[0], titel: groep.files[0].name, thumbs: thumbs, gekozen: isGekozen(groep.files[0].url))
                        }
                        .buttonStyle(.plain)
                        .contextMenu {
                            Button {
                                shareFile = groep.files[0]
                            } label: {
                                Label("Deel", systemImage: "square.and.arrow.up")
                            }
                            Button(role: .destructive) {
                                fileToDelete = groep.files[0]
                            } label: {
                                Label("Verwijder", systemImage: "trash")
                            }
                        }
                    }
                }
            }
        }
    }

    // MARK: Voorbeeldscans

    private var voorbeelden: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .firstTextBaseline) {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Voorbeeldscans")
                        .font(.medTitle())
                        .foregroundColor(Med.textPri)
                    Text("Hartkatheterisatie: de kransslagaders in beeld")
                        .font(.system(size: 13))
                        .foregroundColor(Med.textSec)
                }
                Spacer()
                Button {
                    withAnimation(.easeInOut(duration: 0.2)) { demosHidden.toggle() }
                } label: {
                    Text(demosHidden ? "Toon" : "Verberg")
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(Med.accentText)
                }
            }
            .padding(.top, 6)

            if !demosHidden {
                VStack(spacing: 10) {
                    ForEach(store.bundledDemos) { file in
                        Button { open(file, titel: demoViewerTitel(file)) } label: {
                            ScanRow(file: file, titel: demoTitel(file), thumbs: thumbs, gekozen: isGekozen(file.url))
                        }
                        .buttonStyle(.plain)
                    }
                }
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
    }

    /// Korte titel voor in de lijst.
    private func demoTitel(_ file: DICOMFileInfo) -> String {
        switch file.name {
        case "cag_voor_ingreep":    return "Vóór de ingreep"
        case "cag_tijdens_ingreep": return "Tijdens de ingreep"
        case "cag_na_ingreep":      return "Na de ingreep"
        default: return file.name
        }
    }

    /// Volledige titel voor in de viewer.
    private func demoViewerTitel(_ file: DICOMFileInfo) -> String {
        demoTitel(file)
    }

    private func sectieKop(_ tekst: String) -> some View {
        Text(tekst)
            .font(.medTitle())
            .foregroundColor(Med.textPri)
            .padding(.top, 6)
    }

    // MARK: Tip naar Leren

    private var lerenTip: some View {
        Button(action: openLeren) {
            HStack(spacing: 12) {
                Image(systemName: "lightbulb")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(Color(hex: "8DB8FF"))
                (Text("Wat doet Window/Level met een scan? ")
                 + Text("Lees het in Leren").bold())
                    .font(.system(size: 14))
                    .foregroundColor(Color(hex: "D6E4FF"))
                    .multilineTextAlignment(.leading)
                Spacer(minLength: 0)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .background(Med.blue.opacity(0.14), in: RoundedRectangle(cornerRadius: 20))
            .overlay(RoundedRectangle(cornerRadius: 20).stroke(Med.blue.opacity(0.30), lineWidth: 1))
        }
        .buttonStyle(.plain)
    }

    // MARK: Loading overlay

    private var loadingOverlay: some View {
        ZStack {
            Color.black.opacity(0.5).ignoresSafeArea()
            VStack(spacing: 14) {
                ProgressView()
                    .tint(Med.accentText)
                    .scaleEffect(1.3)
                Text("Scan laden…")
                    .font(.system(size: 15, weight: .medium))
                    .foregroundColor(Med.textPri)
            }
            .padding(28)
            .medGlass(cornerRadius: 24)
        }
    }

    // MARK: Open

    /// Opent een hele serie: parst elk bestand (in instance-volgorde) en
    /// plakt alle frames achter elkaar — de viewer toont ze met slider/cine.
    private func openSeries(_ groep: SeriesGroup) {
        if let eerste = groep.files.first { store.registreerOpening(eerste.url) }
        selectedInfo = groep.files.first
        viewerTitel = groep.description
        isParsing = true
        Task.detached(priority: .userInitiated) {
            var alleFrames: [CGImage] = []
            var eerste: ParsedDICOM?
            for file in groep.files {
                guard let parsed = try? DICOMParser.parse(url: file.url) else { continue }
                if eerste == nil { eerste = parsed }
                alleFrames.append(contentsOf: parsed.frames)
            }
            await MainActor.run {
                isParsing = false
                guard let basis = eerste, !alleFrames.isEmpty else {
                    errorMessage = "Geen leesbare beelden in deze serie."
                    return
                }
                parsedDICOM = ParsedDICOM(
                    patientName: basis.patientName,
                    modality: basis.modality,
                    rows: basis.rows, columns: basis.columns,
                    frames: alleFrames,
                    windowCenter: basis.windowCenter,
                    windowWidth: basis.windowWidth,
                    pixelSpacing: basis.pixelSpacing)
                parsedImage = nil
                viewerID = UUID()
                showViewer = true
            }
        }
    }

    private func open(_ file: DICOMFileInfo, titel: String? = nil) {
        store.registreerOpening(file.url)
        selectedInfo = file
        viewerTitel  = titel ?? file.name
        isParsing    = true
        Task.detached(priority: .userInitiated) {
            do {
                let parsed = try DICOMParser.parse(url: file.url)
                await MainActor.run {
                    parsedDICOM = parsed
                    parsedImage = nil
                    viewerID    = UUID()
                    isParsing   = false
                    showViewer  = true
                }
            } catch DICOMError.notDICOM {
                if let img = UIImage(contentsOfFile: file.url.path) {
                    await MainActor.run {
                        parsedImage = img
                        parsedDICOM = nil
                        viewerID    = UUID()
                        isParsing   = false
                        showViewer  = true
                    }
                } else {
                    await MainActor.run {
                        isParsing    = false
                        errorMessage = "Dit bestandsformaat wordt niet ondersteund."
                    }
                }
            } catch {
                await MainActor.run {
                    isParsing    = false
                    errorMessage = error.localizedDescription
                }
            }
        }
    }
}

// MARK: - Scan-rij (kaart met miniatuur)

private struct ScanRow: View {
    let file: DICOMFileInfo
    let titel: String
    @ObservedObject var thumbs: ThumbCache
    var serie: SeriesGroup? = nil
    var gekozen: Bool = false

    private var info: ThumbCache.Info? { thumbs.info[file.url] }

    var body: some View {
        HStack(spacing: 14) {
            ZStack {
                RoundedRectangle(cornerRadius: 14)
                    .fill(Color(hex: "0B0F16"))
                if let img = info?.image {
                    Image(uiImage: img)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } else {
                    Image(systemName: serie != nil ? "square.stack.3d.up" : "waveform.and.magnifyingglass")
                        .font(.system(size: 22, weight: .medium))
                        .foregroundColor(Med.accentText)
                }
            }
            .frame(width: 64, height: 64)
            .clipShape(RoundedRectangle(cornerRadius: 14))
            .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color.white.opacity(0.08), lineWidth: 1))

            VStack(alignment: .leading, spacing: 6) {
                Text(titel)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(Med.textPri)
                    .lineLimit(1)
                HStack(spacing: 6) {
                    if !modaliteit.isEmpty { MedBadge(text: modaliteit) }
                    Text(meta)
                        .font(.system(size: 13))
                        .foregroundColor(Med.textSec)
                        .lineLimit(1)
                }
            }

            Spacer(minLength: 0)

            Image(systemName: "chevron.right")
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(Med.textDim)
        }
        .padding(10)
        .medCard()
        .overlay(RoundedRectangle(cornerRadius: 20).stroke(Med.accent, lineWidth: gekozen ? 2 : 0))
        .contentShape(Rectangle())
        .onAppear { thumbs.laad(file.url) }
    }

    private var modaliteit: String {
        if let s = serie, !s.modality.isEmpty { return s.modality }
        if let m = info?.modality, !m.isEmpty { return m }
        return file.ext == "DCM" || file.ext == "DICOM" ? "" : file.ext
    }

    private var meta: String {
        if let s = serie {
            return "Serie · \(s.files.count) slices · \(s.totalSize.asFileSize())"
        }
        var delen: [String] = []
        if let n = info?.frames, n > 1 { delen.append("Cine · \(n) beelden") }
        else if let sz = info?.size, !sz.isEmpty { delen.append(sz) }
        if !file.url.path.hasPrefix(Bundle.main.bundlePath) {
            delen.append(file.modifiedAgo)
        }
        return delen.isEmpty ? file.sizeHuman : delen.joined(separator: " · ")
    }
}

// MARK: - Quick image viewer

private struct QuickImageView: View {
    let image: UIImage
    let title: String
    var ingebed = false
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack(alignment: .top) {
            Color.black.ignoresSafeArea()
            Image(uiImage: image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            HStack(spacing: 10) {
                if !ingebed {
                    Button { dismiss() } label: {
                        Image(systemName: "xmark")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(Med.textPri)
                            .medGlassCircle()
                    }
                    .accessibilityLabel("Sluiten")
                }
                Text(title)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(Med.textPri)
                    .lineLimit(1)
                    .padding(.horizontal, 16)
                    .frame(height: 44)
                    .medGlass(cornerRadius: 22)
                Spacer(minLength: 0)
            }
            .padding(.horizontal, 16)
            .padding(.top, 8)
        }
    }
}

