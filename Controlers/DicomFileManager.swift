import Foundation
import Combine

final class FileStore: ObservableObject {
    @Published var files: [DICOMFileInfo] = []

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
