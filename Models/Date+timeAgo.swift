//
//  Date+timeAgo.swift
//  dicom player
//  Created by Ed Cafferata on 31/01/2021.
//  Copyright © 2021 Cafferata. All rights reserved.
//
import Foundation
extension Date {
    /// Relatieve tijd ("3 dagen geleden", "3 days ago", …) in de taal van het toestel.
    func timeAgo(numericDates: Bool) -> String {
        let f = RelativeDateTimeFormatter()
        f.unitsStyle = .full
        f.dateTimeStyle = numericDates ? .numeric : .named
        return f.localizedString(for: self, relativeTo: Date())
    }
}
