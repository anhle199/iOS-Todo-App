//
//  Date+Extension.swift
//  Todo
//
//  Created by Le Hoang Anh on 26/02/2022.
//

import Foundation

extension Date {
    // Returns a moment which is today at 00:00:00
    static func getStartOfDate(from date: Date) -> Date {
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
    static func getEndOfDate(from date: Date) -> Date {
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
}
