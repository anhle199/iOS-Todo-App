//
//  TaskItem.swift
//  Todo
//
//  Created by Le Hoang Anh on 25/02/2022.
//

import Foundation

struct TaskItem {
    var title: String
    var description: String
    var dueTime: Date?
    var isImportant: Bool
    var isDone: Bool
    
    static let `default` = TaskItem(
        title: "",
        description: "",
        dueTime: nil,
        isImportant: false,
        isDone: false
    )
}
