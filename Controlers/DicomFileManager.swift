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
        copyBundledDemoIfNeeded()
        reload()
    }

    private func copyBundledDemoIfNeeded() {
        let dest = docsURL.appendingPathComponent("demo_cag.dcm")
        guard !fm.fileExists(atPath: dest.path),
              let src = Bundle.main.url(forResource: "demo_cag", withExtension: "dcm")
        else { return }
        try? fm.copyItem(at: src, to: dest)
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
            DispatchQueue.main.async { self.reload() }
        } catch {
            print("[FileStore] import failed: \(error.localizedDescription)")
        }
    }

    func delete(_ file: DICOMFileInfo) {
        try? fm.removeItem(at: file.url)
        reload()
    }
}
