//
//  TaskCollectionViewCellViewModel.swift
//  Todo
//
//  Created by Le Hoang Anh on 25/02/2022.
//

import Foundation

struct TaskCollectionViewCellViewModel {
    let taskName: String
    let taskDescription: String
    let dueTime: String
    private let dueDateAndTime: Date
    
    init(title: String, description: String, dueTime: Date) {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        
        self.taskName = title
        self.taskDescription = description
        self.dueTime = formatter.string(for: dueTime) ?? ""
        self.dueDateAndTime = dueTime
    }
    
    func getDueDateAndTime() -> Date {
        return dueDateAndTime
    }
}
