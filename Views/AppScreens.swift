import SwiftUI
import StoreKit

// MARK: - Tabbalk (Scans · Leren · Over)

struct RootTabView: View {
    @State private var tab: Int = {
        #if DEBUG
        // Testhulp: `-startTab <n>` opent direct tab n (alleen debug-builds).
        return UserDefaults.standard.integer(forKey: "startTab")
        #else
        return 0
        #endif
    }()

    var body: some View {
        TabView(selection: $tab) {
            ScansView(openLeren: { tab = 1 })
                .tabItem { Label("Scans", systemImage: "square.grid.2x2") }
                .tag(0)
            LerenView()
                .tabItem { Label("Leren", systemImage: "graduationcap") }
                .tag(1)
            OverView()
                .tabItem { Label("Over", systemImage: "info.circle") }
                .tag(2)
        }
        .tint(Med.accentText)
        .preferredColorScheme(.dark)
    }
}

// MARK: - Gedeelde schermkop

struct MedScreenHeader<Trailing: View>: View {
    let title: LocalizedStringKey
    let subtitle: LocalizedStringKey
    @ViewBuilder var trailing: () -> Trailing

    var body: some View {
        HStack(alignment: .bottom, spacing: 10) {
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.medLargeTitle())
                    .foregroundColor(Med.textPri)
                Text(subtitle)
                    .font(.system(size: 15))
                    .foregroundColor(Med.textSec)
            }
            Spacer(minLength: 0)
            trailing()
                .padding(.bottom, 2)
        }
    }
}

extension MedScreenHeader where Trailing == EmptyView {
    init(title: LocalizedStringKey, subtitle: LocalizedStringKey) {
        self.init(title: title, subtitle: subtitle, trailing: { EmptyView() })
    }
}

// MARK: - Leren

private struct Modaliteit: Identifiable {
    let id: String      // DICOM-code
    let naam: LocalizedStringResource
    let kort: LocalizedStringResource
    let uitleg: LocalizedStringResource
}

private let modaliteiten: [Modaliteit] = [
    Modaliteit(id: "CT", naam: "CT-scan", kort: "Doorsnedes met röntgen",
               uitleg: "Een CT-scanner maakt met röntgenstraling dunne doorsnedes van het lichaam. De grijswaarden zijn Hounsfield-eenheden (HU): lucht is −1000, water 0 en bot enkele honderden tot boven de 1000. Daarom werken de Window/Level-presets in deze app met HU."),
    Modaliteit(id: "MR", naam: "MRI", kort: "Magneetveld, veel detail",
               uitleg: "MRI gebruikt een sterk magneetveld en radiogolven, zonder röntgenstraling. Het toont weke delen zoals hersenen, spieren en gewrichten in veel detail. De grijswaarden hebben geen vaste schaal zoals bij CT."),
    Modaliteit(id: "XA", naam: "Angiografie", kort: "Bloedvaten, als film",
               uitleg: "Bij angiografie worden bloedvaten zichtbaar gemaakt met contrastvloeistof, terwijl er röntgenbeelden worden gemaakt. Vaak als korte film (cine). De voorbeeldscans in deze app zijn opnames van de kransslagaders."),
    Modaliteit(id: "US", naam: "Echo", kort: "Geluidsgolven, geen straling",
               uitleg: "Echografie maakt beelden met geluidsgolven, zonder straling. Het beeld is live; in een DICOM-bestand staan losse beelden of korte filmpjes."),
    Modaliteit(id: "CR", naam: "Röntgenfoto", kort: "Eén projectiebeeld",
               uitleg: "Een gewone röntgenfoto (CR of DX) is één projectiebeeld, bijvoorbeeld van botten of longen. Alles wat de straling tegenhoudt, zoals bot, wordt licht."),
    Modaliteit(id: "MG", naam: "Mammografie", kort: "Röntgen van de borst",
               uitleg: "Een mammografie is een röntgenfoto van de borst met een lage dosis straling. De beelden zijn groot en zeer gedetailleerd."),
]

struct LerenView: View {
    @State private var wlOpen = false
    @State private var gekozen: Modaliteit?

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                MedScreenHeader(title: "Leren", subtitle: "Korte uitleg over medische beelden")

                windowLevelKaart

                Text("Soorten scans")
                    .font(.medTitle())
                    .foregroundColor(Med.textPri)
                    .padding(.top, 6)

                LazyVGrid(columns: [GridItem(.flexible(), spacing: 10), GridItem(.flexible(), spacing: 10)], spacing: 10) {
                    ForEach(modaliteiten) { m in
                        Button { gekozen = m } label: {
                            VStack(alignment: .leading, spacing: 6) {
                                MedBadge(text: m.id)
                                Text(m.naam)
                                    .font(.system(size: 15, weight: .semibold))
                                    .foregroundColor(Med.textPri)
                                Text(m.kort)
                                    .font(.system(size: 12))
                                    .foregroundColor(Med.textSec)
                                    .multilineTextAlignment(.leading)
                            }
                            .frame(maxWidth: .infinity, minHeight: 92, alignment: .topLeading)
                            .padding(14)
                            .medCard()
                        }
                        .buttonStyle(.plain)
                    }
                }

                viewerTips

                waarschuwing
            }
            .padding(.horizontal, 20)
            .padding(.top, 8)
            .padding(.bottom, 24)
            .frame(maxWidth: 680)
            .frame(maxWidth: .infinity)
        }
        .background(Med.bg.ignoresSafeArea())
        .medGlow(Med.blue, alignment: .topLeading)
        .sheet(item: $gekozen) { m in
            ModaliteitSheet(m: m)
        }
    }

    private var windowLevelKaart: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("UITGELICHT")
                .font(.system(size: 12, weight: .bold))
                .foregroundColor(Med.accentText)
            Text("Window/Level in één minuut")
                .font(.medTitle())
                .foregroundColor(Med.textPri)

            VStack(spacing: 12) {
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        LinearGradient(stops: [
                            .init(color: .black, location: 0.30),
                            .init(color: .white, location: 0.62)
                        ], startPoint: .leading, endPoint: .trailing)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Med.accent, lineWidth: 2)
                            .frame(width: geo.size.width * 0.32, height: 36)
                            .offset(x: geo.size.width * 0.30)
                    }
                }
                .frame(height: 26)
                HStack {
                    Text("donker")
                    Spacer()
                    Text("venster").foregroundColor(Med.accentText).fontWeight(.semibold)
                    Spacer()
                    Text("licht")
                }
                .font(.system(size: 12))
                .foregroundColor(Med.textSec)
            }

            Text("**Window** bepaalt het contrast: hoe breed het grijsbereik is. **Level** bepaalt de helderheid: waar het midden ligt.")
                .font(.system(size: 14))
                .foregroundColor(Color(hex: "C3CEDF"))
                .lineSpacing(2)

            if wlOpen {
                Text("Een medisch beeld bevat veel meer grijstinten dan een scherm kan tonen. Window/Level kiest welk stukje je ziet. Een smal venster geeft veel contrast, een breed venster meer overzicht. Bij CT gebruikt de app vaste presets, zoals Long (L −600, W 1500) en Hersenen (L 40, W 80). Die kies je in de viewer onderin.")
                    .font(.system(size: 14))
                    .foregroundColor(Color(hex: "C3CEDF"))
                    .lineSpacing(2)
                    .transition(.opacity)
            }

            Button {
                withAnimation(.easeInOut(duration: 0.2)) { wlOpen.toggle() }
            } label: {
                Text(wlOpen ? "Minder" : "Lees verder")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(Med.accentText)
            }
        }
        .padding(18)
        .medCard(cornerRadius: 24)
    }

    private var viewerTips: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Handig in de viewer")
                .font(.medTitle())
                .foregroundColor(Med.textPri)
            VStack(spacing: 0) {
                tipRij("arrow.up.left.and.arrow.down.right", "Knijp om in en uit te zoomen")
                MedDivider().padding(.leading, 58)
                tipRij("hand.draw", "Sleep om het beeld te verplaatsen")
                MedDivider().padding(.leading, 58)
                tipRij("hand.tap", "Dubbeltik om terug te zetten")
                MedDivider().padding(.leading, 58)
                tipRij("eye.slash", "Tik één keer om de knoppen te verbergen")
            }
            .medCard()
        }
        .padding(.top, 6)
    }

    private func tipRij(_ icoon: String, _ tekst: LocalizedStringKey) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icoon)
                .font(.system(size: 15, weight: .semibold))
                .foregroundColor(Med.accentText)
                .frame(width: 32, height: 32)
                .background(Med.accent.opacity(0.16), in: RoundedRectangle(cornerRadius: 10))
            Text(tekst)
                .font(.system(size: 15))
                .foregroundColor(Med.textPri)
            Spacer(minLength: 0)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 11)
    }

    private var waarschuwing: some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: "exclamationmark.triangle")
                .foregroundColor(Color(hex: "F5B547"))
            Text("Bedoeld om te leren en te bekijken, niet om een diagnose te stellen.")
                .font(.system(size: 13))
                .foregroundColor(Color(hex: "F6DDB0"))
            Spacer(minLength: 0)
        }
        .padding(14)
        .background(Med.warn.opacity(0.12), in: RoundedRectangle(cornerRadius: 18))
        .overlay(RoundedRectangle(cornerRadius: 18).stroke(Med.warn.opacity(0.32), lineWidth: 1))
    }
}

private struct ModaliteitSheet: View {
    let m: Modaliteit
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                MedBadge(text: m.id)
                Spacer()
                Button { dismiss() } label: {
                    Image(systemName: "xmark")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(Med.textPri)
                        .medGlassCircle()
                }
                .accessibilityLabel("Sluiten")
            }
            Text(m.naam)
                .font(.system(size: 28, weight: .heavy))
                .foregroundColor(Med.textPri)
            Text(m.uitleg)
                .font(.system(size: 16))
                .foregroundColor(Color(hex: "C3CEDF"))
                .lineSpacing(3)
            Spacer(minLength: 0)
        }
        .padding(24)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .background(Med.bg.ignoresSafeArea())
        .presentationDetents([.medium])
        .preferredColorScheme(.dark)
    }
}

// MARK: - Over

private let fooien: [(id: String, naam: LocalizedStringResource, prijs: String)] = [
    ("info.cafferata.dicomplayer.tip.small", "Koffie", "€ 0,99"),
    ("info.cafferata.dicomplayer.tip.medium", "Lunch", "€ 2,99"),
    ("info.cafferata.dicomplayer.tip.large", "Diner", "€ 9,99"),
]

struct OverView: View {
    @StateObject private var tips = TipStore()
    @Environment(\.openURL) private var openURL

    private var versie: String {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                HStack(spacing: 14) {
                    Image("OverIcon")
                        .resizable()
                        .frame(width: 64, height: 64)
                        .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
                        .overlay(RoundedRectangle(cornerRadius: 15, style: .continuous).stroke(Color.white.opacity(0.14), lineWidth: 1))
                        .accessibilityHidden(true)
                    VStack(alignment: .leading, spacing: 3) {
                        Text("Dicom Viewer")
                            .font(.system(size: 26, weight: .heavy))
                            .foregroundColor(Med.textPri)
                        Text("by The IT Crowd · versie \(versie)")
                            .font(.system(size: 14))
                            .foregroundColor(Med.textSec)
                    }
                }

                VStack(spacing: 0) {
                    feitRij("Geen account nodig", "Openen en meteen kijken")
                    MedDivider().padding(.leading, 60)
                    feitRij("Alles blijft op je toestel", "Geen upload, geen tracking")
                    MedDivider().padding(.leading, 60)
                    feitRij("Werkt offline", "Ook zonder internet")
                }
                .medCard(cornerRadius: 22)

                fooienKaart

                VStack(spacing: 0) {
                    linkRij("Hulp en contact", "https://cafferata.info/dicom-viewer/support.html")
                    MedDivider().padding(.leading, 16)
                    linkRij("Privacybeleid", "https://cafferata.info/dicom-viewer/privacy.html")
                    MedDivider().padding(.leading, 16)
                    linkRij("Beoordeel de app", "https://apps.apple.com/app/id1483496527?action=write-review")
                    MedDivider().padding(.leading, 16)
                    linkRij("Ook op Android", "https://play.google.com/store/apps/details?id=info.cafferata.dicomviewer")
                }
                .medCard(cornerRadius: 22)

                Text("Dicom Viewer is bedoeld om te leren en te bekijken. Het is geen medisch hulpmiddel en niet geschikt om een diagnose te stellen.")
                    .font(.system(size: 12))
                    .foregroundColor(Med.textDim)
                    .padding(.horizontal, 4)
            }
            .padding(.horizontal, 20)
            .padding(.top, 8)
            .padding(.bottom, 24)
            .frame(maxWidth: 680)
            .frame(maxWidth: .infinity)
        }
        .background(Med.bg.ignoresSafeArea())
        .medGlow(Med.accent, alignment: .topLeading)
    }

    private func feitRij(_ titel: LocalizedStringKey, _ sub: LocalizedStringKey) -> some View {
        HStack(spacing: 12) {
            Image(systemName: "checkmark")
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(Med.accentText)
                .frame(width: 32, height: 32)
                .background(Med.accent.opacity(0.16), in: RoundedRectangle(cornerRadius: 10))
            VStack(alignment: .leading, spacing: 1) {
                Text(titel).font(.system(size: 15, weight: .semibold)).foregroundColor(Med.textPri)
                Text(sub).font(.system(size: 13)).foregroundColor(Med.textSec)
            }
            Spacer(minLength: 0)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }

    private func linkRij(_ titel: LocalizedStringKey, _ adres: String) -> some View {
        Button {
            if let url = URL(string: adres) { openURL(url) }
        } label: {
            HStack {
                Text(titel).font(.system(size: 15)).foregroundColor(Med.textPri)
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(Med.textDim)
            }
            .padding(.horizontal, 16)
            .frame(minHeight: 48)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }

    private var fooienKaart: some View {
        VStack(alignment: .leading, spacing: 12) {
            VStack(alignment: .leading, spacing: 3) {
                Text("Steun de maker")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(Med.textPri)
                Text(tips.purchased.isEmpty
                     ? "De app blijft gratis en zonder reclame. Een fooi helpt."
                     : "Dank je wel! Dit betekent veel.")
                    .font(.system(size: 13))
                    .foregroundColor(Color(hex: "E3C9CE"))
            }
            HStack(spacing: 8) {
                ForEach(fooien, id: \.id) { f in
                    let product = tips.products.first { $0.id == f.id }
                    let gekocht = tips.purchased.contains(f.id)
                    Button {
                        guard !gekocht else { return }
                        Task { await tips.purchaseByID(f.id) }
                    } label: {
                        VStack(spacing: 2) {
                            Text(f.naam).font(.system(size: 13, weight: .semibold))
                            if tips.purchasing == f.id {
                                ProgressView().tint(Med.textPri).scaleEffect(0.8)
                            } else if gekocht {
                                Image(systemName: "checkmark.circle.fill").foregroundColor(Med.accentText)
                            } else {
                                Text(product?.displayPrice ?? f.prijs).font(.system(size: 15, weight: .heavy))
                            }
                        }
                        .foregroundColor(Med.textPri)
                        .frame(maxWidth: .infinity, minHeight: 64)
                        .background(Color.white.opacity(0.07), in: RoundedRectangle(cornerRadius: 16))
                        .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.white.opacity(0.14), lineWidth: 1))
                    }
                    .buttonStyle(.plain)
                    .disabled(tips.purchasing != nil)
                }
            }
            Button {
                Task { await tips.restore() }
            } label: {
                Text("Aankopen herstellen")
                    .font(.system(size: 13))
                    .foregroundColor(Med.textSec)
                    .underline()
            }
            .frame(maxWidth: .infinity)
        }
        .padding(16)
        .background(Med.heart.opacity(0.08), in: RoundedRectangle(cornerRadius: 22))
        .overlay(RoundedRectangle(cornerRadius: 22).stroke(Med.heart.opacity(0.28), lineWidth: 1))
    }
}

// MARK: - Miniaturen

/// Maakt op de achtergrond een miniatuur + aantal beelden per bestand.
@MainActor
final class ThumbCache: ObservableObject {
    static let shared = ThumbCache()

    struct Info {
        let image: UIImage?
        let frames: Int
        let modality: String
        let size: String
    }

    @Published private(set) var info: [URL: Info] = [:]
    private var bezig: Set<URL> = []

    func laad(_ url: URL) {
        guard info[url] == nil, !bezig.contains(url) else { return }
        bezig.insert(url)
        Task.detached(priority: .utility) {
            let resultaat = ThumbCache.maak(url)
            await MainActor.run {
                self.info[url] = resultaat
                self.bezig.remove(url)
            }
        }
    }

    nonisolated private static func maak(_ url: URL) -> Info {
        let grootte = (try? url.resourceValues(forKeys: [.fileSizeKey]).fileSize) ?? 0
        let sleutel = cacheSleutel(url, grootte: grootte)
        if let bewaard = leesCache(sleutel) { return bewaard }
        let info = maakNieuw(url, grootte: grootte)
        schrijfCache(info, sleutel: sleutel)
        return info
    }

    // MARK: Schijfcache (Caches/Miniaturen) — parsen gebeurt maar één keer per bestand

    nonisolated private static var cacheMap: URL {
        let map = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("Miniaturen", isDirectory: true)
        try? FileManager.default.createDirectory(at: map, withIntermediateDirectories: true)
        return map
    }

    nonisolated private static func cacheSleutel(_ url: URL, grootte: Int) -> String {
        let datum = (try? url.resourceValues(forKeys: [.contentModificationDateKey]).contentModificationDate)?
            .timeIntervalSince1970 ?? 0
        let ruw = "\(url.lastPathComponent)-\(grootte)-\(Int(datum))"
        return String(ruw.map { $0.isLetter || $0.isNumber || $0 == "-" ? $0 : "_" })
    }

    nonisolated private static func leesCache(_ sleutel: String) -> Info? {
        let meta = cacheMap.appendingPathComponent(sleutel + ".json")
        guard let data = try? Data(contentsOf: meta),
              let d = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else { return nil }
        let png = cacheMap.appendingPathComponent(sleutel + ".png")
        return Info(image: UIImage(contentsOfFile: png.path),
                    frames: d["frames"] as? Int ?? 0,
                    modality: d["modality"] as? String ?? "",
                    size: d["size"] as? String ?? "")
    }

    nonisolated private static func schrijfCache(_ info: Info, sleutel: String) {
        let d: [String: Any] = ["frames": info.frames, "modality": info.modality, "size": info.size]
        if let png = info.image?.pngData() {
            try? png.write(to: cacheMap.appendingPathComponent(sleutel + ".png"))
        }
        if let data = try? JSONSerialization.data(withJSONObject: d) {
            try? data.write(to: cacheMap.appendingPathComponent(sleutel + ".json"))
        }
    }

    nonisolated private static func maakNieuw(_ url: URL, grootte: Int) -> Info {
        // Grote bestanden niet volledig parsen alleen voor een miniatuur.
        if grootte < 40_000_000, let p = try? DICOMParser.parse(url: url), let eerste = p.frames.first {
            let klein = UIImage(cgImage: eerste).preparingThumbnail(of: CGSize(width: 160, height: 160))
            return Info(image: klein, frames: p.frames.count, modality: p.modality,
                        size: "\(p.columns) × \(p.rows)")
        }
        if grootte < 40_000_000, let img = UIImage(contentsOfFile: url.path) {
            return Info(image: img.preparingThumbnail(of: CGSize(width: 160, height: 160)),
                        frames: 1, modality: "", size: "")
        }
        return Info(image: nil, frames: 0, modality: "", size: "")
    }
}
