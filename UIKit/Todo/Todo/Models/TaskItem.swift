//
//  TaskItem.swift
//  Todo
//
//  Created by Le Hoang Anh on 25/02/2022.
//

import Foundation
import RealmSwift

class TaskItem: Object {
    @Persisted var title: String
    @Persisted var taskDescription: String = ""
    @Persisted var dueTime: Date
    @Persisted var isImportant: Bool = false
    @Persisted var isDone: Bool = false
    @Persisted var createdAt: Date
}

struct TaskItemNonRealmObject: Equatable {
    var title: String
    var taskDescription: String
    var dueTime: Date
    var isImportant: Bool
    var isDone: Bool
    var createdAt: Date
    
    init(from taskItem: TaskItem) {
        self.title = taskItem.title
        self.taskDescription = taskItem.taskDescription
        self.dueTime = taskItem.dueTime
        self.isImportant = taskItem.isImportant
        self.isDone = taskItem.isDone
        self.createdAt = taskItem.createdAt
    }
    
    init() {
        self.title = ""
        self.taskDescription = ""
        self.dueTime = .getEndOfDate(from: .now)
        self.isImportant = false
        self.isDone = false
        self.createdAt = .now
    }
}
