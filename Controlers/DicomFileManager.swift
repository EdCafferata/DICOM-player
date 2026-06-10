import Foundation
import Combine

/// Eén DICOM-serie: bestanden met dezelfde Series Instance UID,
/// gesorteerd op Instance Number. Losse bestanden krijgen elk hun eigen groep.
struct SeriesGroup: Identifiable {
    let id: String               // seriesUID, of file-path voor losse bestanden
    let description: String      // seriesDescription of bestandsnaam
    let modality: String
    let files: [DICOMFileInfo]   // gesorteerd op instanceNumber

    var isSeries: Bool { files.count > 1 }
    var totalSize: Int { files.reduce(0) { $0 + $1.fileSize } }
}

final class FileStore: ObservableObject {
    @Published var files: [DICOMFileInfo] = []
    @Published var series: [SeriesGroup] = []
    @Published var recent: [DICOMFileInfo] = []

    private let recentKey = "recentGeopend"
    private let maxRecent = 5

    static let shared = FileStore()

    private let fm   = FileManager.default
    private var docsURL: URL {
        fm.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }

    init() {
        reload()
    }

    func reload() {
        guard let contents = try? fm.contentsOfDirectory(
            at: docsURL,
            includingPropertiesForKeys: [.contentModificationDateKey, .fileSizeKey],
            options: .skipsSubdirectoryDescendants
        ) else { return }

        files = contents
            .filter { !$0.lastPathComponent.hasPrefix(".") }
            .map    { DICOMFileInfo(url: $0) }
            .sorted { $0.modifiedDate > $1.modifiedDate }

        groepeerSeries(files)
        herlaadRecent()
    }

    // MARK: Recent geopend (laatste 5)

    /// Registreert dat een bestand geopend is; bewaart alleen bestandsnamen
    /// (geen paden — de Documents-map verhuist tussen app-updates).
    func registreerOpening(_ url: URL) {
        var namen = UserDefaults.standard.stringArray(forKey: recentKey) ?? []
        namen.removeAll { $0 == url.lastPathComponent }
        namen.insert(url.lastPathComponent, at: 0)
        UserDefaults.standard.set(Array(namen.prefix(maxRecent)), forKey: recentKey)
        herlaadRecent()
    }

    private func herlaadRecent() {
        let namen = UserDefaults.standard.stringArray(forKey: recentKey) ?? []
        recent = namen.compactMap { naam in
            files.first { $0.url.lastPathComponent == naam }
        }
    }

    /// Groepeert bestanden op Series Instance UID (achtergrond-thread; alleen
    /// headers worden gelezen, geen pixeldata).
    private func groepeerSeries(_ bestanden: [DICOMFileInfo]) {
        Task.detached(priority: .userInitiated) {
            var perUID: [String: [(DICOMFileInfo, Int)]] = [:]
            var volgordeUID: [String] = []   // volgorde van eerste verschijning
            var los: [SeriesGroup] = []
            var omschrijving: [String: String] = [:]
            var modaliteit: [String: String] = [:]

            for file in bestanden {
                if let h = DICOMParser.parseHeader(url: file.url), !h.seriesUID.isEmpty {
                    if perUID[h.seriesUID] == nil { volgordeUID.append(h.seriesUID) }
                    perUID[h.seriesUID, default: []].append((file, h.instanceNumber))
                    if omschrijving[h.seriesUID] == nil, !h.seriesDescription.isEmpty {
                        omschrijving[h.seriesUID] = h.seriesDescription
                    }
                    if modaliteit[h.seriesUID] == nil, !h.modality.isEmpty {
                        modaliteit[h.seriesUID] = h.modality
                    }
                } else {
                    los.append(SeriesGroup(
                        id: file.url.path, description: file.name,
                        modality: "", files: [file]))
                }
            }

            let groepen: [SeriesGroup] = volgordeUID.map { uid in
                let items = perUID[uid]!.sorted { $0.1 < $1.1 }
                return SeriesGroup(
                    id: uid,
                    description: omschrijving[uid] ?? items[0].0.name,
                    modality: modaliteit[uid] ?? "",
                    files: items.map { $0.0 })
            }

            let resultaat = groepen + los
            await MainActor.run { self.series = resultaat }
        }
    }

    /// Copies a security-scoped URL into Documents and reloads the list.
    func importFile(from url: URL) {
        let accessed = url.startAccessingSecurityScopedResource()
        defer { if accessed { url.stopAccessingSecurityScopedResource() } }

        var dest = docsURL.appendingPathComponent(url.lastPathComponent)
        // Guard against path traversal (e.g. a filename of "..").
        guard dest.path.hasPrefix(docsURL.path) else { return }
        // Avoid collisions
        var counter = 1
        while fm.fileExists(atPath: dest.path) {
            let base = url.deletingPathExtension().lastPathComponent
            let ext  = url.pathExtension
            dest = docsURL.appendingPathComponent("\(base)_\(counter).\(ext)")
            counter += 1
        }
        do {
            try fm.copyItem(at: url, to: dest)
            try? (dest as NSURL).setResourceValue(true, forKey: .isExcludedFromBackupKey)
            DispatchQueue.main.async { self.reload() }
        } catch {
            #if DEBUG
            print("[FileStore] import failed: \(error.localizedDescription)")
            #endif
        }
    }

    func delete(_ file: DICOMFileInfo) {
        try? fm.removeItem(at: file.url)
        reload()
    }

    /// DICOM demo files bundled with the app, shown when the user has no own files.
    var bundledDemos: [DICOMFileInfo] {
        ["cag_voor_ingreep", "cag_tijdens_ingreep", "cag_na_ingreep"].compactMap { name in
            Bundle.main.url(forResource: name, withExtension: "dcm")
                .map { DICOMFileInfo(url: $0) }
        }
    }
}
