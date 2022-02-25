//
//  DateButtonViewModel.swift
//  Todo
//
//  Created by Le Hoang Anh on 23/02/2022.
//

import Foundation

struct DateButtonViewModel {
    private let dayNumer: Int
    let dayNumberAsString: String
    let weekdayText: String
    
    init(dayNumber: Int, weekdayInAbbreviation: String) {
        self.init(
            dayNumberAsString: String(format: "%02d", dayNumber),
            weekdayInAbbreviation: weekdayInAbbreviation
        )
    }
    
    init(dayNumberAsString: String, weekdayInAbbreviation: String) {
        self.dayNumer = Int(dayNumberAsString) ?? 1
        self.dayNumberAsString = dayNumberAsString
        self.weekdayText = weekdayInAbbreviation
    }
    
    func getDayNumber() -> Int {
        return dayNumer
    }
}
