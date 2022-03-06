//
//  DateManager.swift
//  Todo
//
//  Created by Le Hoang Anh on 06/03/2022.
//

import Foundation

// MARK: - Singleton Pattern
struct DateManager {

    // MARK: - Apply Singleton Pattern
    static let shared = DateManager()
    private init() {}

    let daysOfWeek = DateManager.getDaysOfWeek()
    let shortWeekdaySymbols = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
    
    // Returns a moment which is today at 00:00:00
    func startTime(of date: Date) -> Date {
        let components = Calendar.current.dateComponents(in: .current, from: date)
        //        guard let day = components.day,
        //              let month = components.month,
        //              let year = components.year
        //        else {
        //            return nil
        //        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy HH:mm:ss"
        
        return formatter.date(
            from: String(
                format: "%d/%d/%d %d:%d:%d",
                components.day!,
                components.month!,
                components.year!,
                0,
                0,
                0
            )
        )!
    }
    
    // Returns a moment which is today at 23:59:59
    func endTime(of date: Date) -> Date {
        let components = Calendar.current.dateComponents(in: .current, from: date)
        //        guard let day = components.day,
        //              let month = components.month,
        //              let year = components.year
        //        else {
        //            return nil
        //        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy HH:mm:ss"
        
        return formatter.date(
            from: String(
                format: "%d/%d/%d %d:%d:%d",
                components.day!,
                components.month!,
                components.year!,
                23,
                59,
                59
            )
        )!
    }
    
    private static func getDaysOfWeek() -> [Date] {
        // Because default in Swift is starts from Sunday
        // And the code below is process to start from Monday
        let yesterday = Date.now.advanced(by: TimeInterval(-86400))
        let calendar = Calendar.current
        let dayOfWeek = calendar.component(.weekday, from: yesterday)
        let weekdays = calendar.range(of: .weekday, in: .weekOfYear, for: yesterday)
        let days = weekdays?.compactMap { weekday in
            return calendar.date(
                byAdding: .day,
                value: weekday - dayOfWeek + 1,
                to: yesterday
            )
        }
        
        return days ?? []
    }
    
}
