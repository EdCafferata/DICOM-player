//
//  DicomFileManager.swift
//  dicom player
//  Created by Ed Cafferata on 31/01/2021.
//  Copyright © 2021 Cafferata. All rights reserved.
//
import Foundation
///
/// Dicom File extension
///
let kFileExt = ["dicom", "DICOM"]
///
/// Class to handle actions with Dicom files (save, delete, etc..)
/// It works on the default document directory of the app.
///
class DicomFileManager: NSObject {
    @IBAction func loadfiles(_ sender: Any) {
    }
    ///
    /// Folder that where all Dicom files are stored
    ///
    class var DicomFilesFolderURL: URL {
        let documentsUrl =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0] as URL
        return documentsUrl
    }
    ///
    /// Gets the list of `.dicom` files in Documents directory ordered by modified date
    ///
    class var fileList: [DicomFileInfo] {
        var DicomFiles: [DicomFileInfo] = []
        let fileManager = FileManager.default
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        do {
            //
            // Get all files from the directory .documentsURL. Of each file get the URL (~path)
            // last modification date and file size
            //
            if let directoryURLs = try? fileManager.contentsOfDirectory(at: documentsURL,
                includingPropertiesForKeys: [.attributeModificationDateKey, .fileSizeKey],
                options: .skipsSubdirectoryDescendants) {
                //
                //Order files based on the date
                // This map creates a tuple (url: URL, modificationDate: String, filesize: Int)
                // and then orders it by modificationDate
                //
                let sortedURLs = directoryURLs.map { url in
                    (url: url,
                     modificationDate: (try? url.resourceValues(forKeys: [.contentModificationDateKey]))?.contentModificationDate ?? Date.distantPast,
                     fileSize: (try? url.resourceValues(forKeys: [.fileSizeKey]))?.fileSize ?? 0)
                    }
                    .sorted(by: { $0.1 > $1.1 }) // sort descending modification dates
                print(sortedURLs)
                //
                // Now we filter Dicom Files
                //
                for (url, modificationDate, fileSize) in sortedURLs {
                    if kFileExt.contains(url.pathExtension) {
                        DicomFiles.append(DicomFileInfo(fileURL: url))
                        let lastPathComponent = url.deletingPathExtension().lastPathComponent
                        print("\(modificationDate) \(modificationDate.timeAgo(numericDates: true)) \(fileSize)bytes -- \(lastPathComponent)")
                    }
                }
            }
        }
        return DicomFiles
    }
    ///
    /// Provides the URL in the DicomFilesFolderURL for the filename provided as argument.
    ///
    /// - Parameters:
    ///     - filename: dicom filename with .dicom extension (f.i: `hola.dicom`) or without extension (f.i: `hola`)
    ///
    class func URLForFilename(_ filename: String) -> URL {
        var fullURL = self.DicomFilesFolderURL.appendingPathComponent(filename)
        print("URLForFilename(\(filename): pathForFilename: \(fullURL)")
        //check if filename has extension
        if  !(kFileExt.contains(fullURL.pathExtension)) {
            fullURL = fullURL.appendingPathExtension(kFileExt[0])
        }
        return fullURL
    }
    ///
    /// Returns true if the file with filename exists on the default folder (DicomFilesFolderURL).
    /// False in othercase.
    ///
    /// - Parameters:
    ///     - filename: Name of the file without extension.
    class func fileExists(_ filename: String) -> Bool {
        let fileURL = self.URLForFilename(filename)
        return FileManager.default.fileExists(atPath: fileURL.path)
    }
    ///
    /// Saves the Dicomcontents to the specified URL
    /// - Parameters:
    ///     - fileURL: destination URL, basically it is file path.
    ///     - dicomContents: String with the contents to be saved. The XML contents of the Dicom file
    ///
    class func saveToURL(_ fileURL: URL, dicomContents: String) {
        //save file
        print("Saving file at path: \(fileURL)")
        // write dicom to file
        var writeError: NSError?
        let saved: Bool
        do {
            try dicomContents.write(toFile: fileURL.path, atomically: true, encoding: String.Encoding.utf8)
            saved = true
        } catch let error as NSError {
            writeError = error
            saved = false
        }
        if !saved {
            if let error = writeError {
                print("[ERROR] DicomFileManager:save: \(error.localizedDescription)")
            }
        }
    }
    ///
    /// Saves in the default folder the filename with the dicomContents
    ///
    /// - Parameters:
    ///     - filename: gpx filename with .gpx extension (f.i: `hola.dicom`) or without extension (f.i: `hola`)
    ///     - dicomContents: String with the contents to be saved. The XML contents of the Dicom file
    ///
    class func save(_ filename: String, dicomContents: String) {
        //check if name exists
        let fileURL: URL = self.URLForFilename(filename)
        DicomFileManager.saveToURL(fileURL, dicomContents: dicomContents)
    }
    ///
    /// Moves temporary files received from Apple Watch app to default directory
    ///
    /// - Parameters:
    ///     - fileURL: URL of temporary file that should be moved/saved.
    ///     - fileName: name of temporary file, including the file extension (`.dicom`)
    ///
    class func moveFrom(_ fileURL: URL, fileName: String?) {
        // check if file name is valid
        guard let fileName = fileName else {
            print("DicomFileManager:: save failed, error: file name is nil")
            return
        }
        // attempt to move file
        do {
            let url = DicomFilesFolderURL.path + "/" + fileName
            try FileManager().moveItem(atPath: fileURL.path, toPath: url)
        }
        // file move failure
        catch {
            print("DicomFileManager:: save failed, error: \(error)")
        }
    }
    /// Removes a file on the specified URL
    class func removeFileFromURL(_ fileURL: URL) {
        print("Removing file at path: \(fileURL)")
        let defaultManager = FileManager.default
        var error: NSError?
        let deleted: Bool
        do {
            try defaultManager.removeItem(atPath: fileURL.path)
            deleted = true
        } catch let error1 as NSError {
            error = error1
            deleted = false
        }
        if !deleted {
            if let e = error {
                print("[ERROR] DicomFileManager:removeFile: \(fileURL) : \(e.localizedDescription)")
            }
        }
    }
    ///
    /// Removes file on the default directory for files
    ///
    /// - Parameters:
    ///     - filename: dicom filename with .dicom extension (f.i: `hola.dicom`) or without extension (f.i: `hola`)
    ///
    class func removeFile(_ filename: String) {
        let fileURL: URL = self.URLForFilename(filename)
        DicomFileManager.removeFileFromURL(fileURL)
    }
    ///
    /// Removes all files on the application temporary directory (NSTemporaryDirectory())
    ///
    class func removeTemporaryFiles() {
        let fileManager = FileManager.default
        do {
            let tmpDirectory = try fileManager.contentsOfDirectory(atPath: NSTemporaryDirectory())
            tmpDirectory.forEach { file in
                let fileURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(file)
                DicomFileManager.removeFileFromURL(fileURL)
            }
        } catch {
            print(error)
        }
    }
}
