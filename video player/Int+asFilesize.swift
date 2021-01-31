//
//  Int+asFilesize.swift
//  dicom player
//
//  Created by Ed Cafferata on 31/01/2021.
//  Copyright © 2021 Cafferata. All rights reserved.
//

import Foundation
/// Extension to display humanized filesizes
extension Int {
    
    /// Returns the integer as file size humanized (for instance: 1024 -> "1 KB" )
    func asFileSize() -> String {
        let bcf = ByteCountFormatter()
        bcf.allowedUnits = [.useAll]
        bcf.countStyle = .file
        let string = bcf.string(fromByteCount: Int64(self))
        //print("formatted result: \(string)")
        return string
    }
}
