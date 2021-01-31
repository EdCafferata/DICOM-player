//
//  DicomFilesTableViewControlllerDelegate.swift
//  dicom player
//
//  Created by Ed Cafferata on 31/01/2021.
//  Copyright © 2021 Cafferata. All rights reserved.
//
import Foundation
///
/// Delegate protocol for the view controller that displays the list of files (DicomFilesTableViewController).
///
/// Used to inform the main ViewController that user wants to load a Dicom File on it.
///
protocol DicomFilesTableViewControllerDelegate: class {
    ///
    /// DicomFilesTableView controller will be dismissed after calling this method
    ///
    /// - Parameters:
    ///       - dicomFile: is the name of the file to load without extension
    ///
    func didLoadDicomFileWithName(_ dicomFilename: String)
}
