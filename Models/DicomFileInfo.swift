import Foundation

struct DICOMFileInfo: Identifiable {
    let id    = UUID()
    let url   : URL
    var name  : String { url.deletingPathExtension().lastPathComponent }
    var ext   : String { url.pathExtension.uppercased() }

    var modifiedDate: Date {
        (try? url.resourceValues(forKeys: [.contentModificationDateKey]))?
            .contentModificationDate ?? .distantPast
    }
    var fileSize: Int {
        (try? url.resourceValues(forKeys: [.fileSizeKey]))?.fileSize ?? 0
    }
    var modifiedAgo:  String { modifiedDate.timeAgo(numericDates: true) }
    var sizeHuman:    String { fileSize.asFileSize() }
}
