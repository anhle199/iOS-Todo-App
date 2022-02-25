//
//  BottomBarViewViewModel.swift
//  Todo
//
//  Created by Le Hoang Anh on 23/02/2022.
//

import Foundation

struct BottomBarViewViewModel {
    let taskCountValue: String
    let selectedDateValue: String
    private let selectedDateAndTime: Date
    
    init(taskCount: String, selectedDate: Date) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        
        self.taskCountValue = taskCount
        self.selectedDateValue = dateFormatter.string(for: selectedDate) ?? ""
        self.selectedDateAndTime = selectedDate
    }
    
    func getSelectedDateAndTime() -> Date {
        return selectedDateAndTime
    }
}
