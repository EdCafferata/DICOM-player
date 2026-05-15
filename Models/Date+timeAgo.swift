//
//  Date+timeAgo.swift
//  dicom player
//  Created by Ed Cafferata on 31/01/2021.
//  Copyright © 2021 Cafferata. All rights reserved.
//
import Foundation
extension Date {
    ///
    /// Provides a humanified date. For instance: 1 minute, 1 week ago, 3 months ago
    ///
    /// - Parameters:
    ///      - numericDates: Set it to true to get "1 year ago", "1 month ago" or false if you prefer "Last year", "Last month"
    ///
    func timeAgo(numericDates: Bool) -> String {
        let calendar = Calendar.current
        let now = Date()
        let earliest = self < now ? self : now
        let latest   = self > now ? self : now

        let unitFlags: Set<Calendar.Component> = [.minute, .hour, .day, .weekOfMonth, .month, .year, .second]
        let components = calendar.dateComponents(unitFlags, from: earliest, to: latest)

        if let year = components.year {
            if year >= 2  { return "\(year) jaar geleden" }
            if year >= 1  { return numericDates ? "1 jaar geleden" : "Vorig jaar" }
        }
        if let month = components.month {
            if month >= 2 { return "\(month) maanden geleden" }
            if month >= 1 { return numericDates ? "1 maand geleden" : "Vorige maand" }
        }
        if let week = components.weekOfMonth {
            if week >= 2  { return "\(week) weken geleden" }
            if week >= 1  { return numericDates ? "1 week geleden" : "Vorige week" }
        }
        if let day = components.day {
            if day >= 2   { return "\(day) dagen geleden" }
            if day >= 1   { return numericDates ? "1 dag geleden" : "Gisteren" }
        }
        if let hour = components.hour {
            if hour >= 2  { return "\(hour) uur geleden" }
            if hour >= 1  { return numericDates ? "1 uur geleden" : "Afgelopen uur" }
        }
        if let minute = components.minute {
            if minute >= 2 { return "\(minute) min geleden" }
            if minute >= 1 { return numericDates ? "1 min geleden" : "Afgelopen minuut" }
        }
        if let second = components.second, second >= 3 {
            return "\(second) sec geleden"
        }
        return "Zojuist"
    }
}
