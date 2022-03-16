//
//  TaskItem.swift
//  ToDo SwiftUI
//
//  Created by Le Hoang Anh on 11/03/2022.
//

import Foundation
import RealmSwift

class TaskItem: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var title: String
    @Persisted var taskDescription: String = ""
    @Persisted var dueTime: Date
    @Persisted var isImportant: Bool = false
    @Persisted var isDone: Bool = false
    @Persisted var createdAt: Date = .now
    
    convenience init(from taskNonRealmObject: TaskItemNonRealmObject) {
        self.init()
        self.title = taskNonRealmObject.title
        self.taskDescription = taskNonRealmObject.taskDescription
        self.dueTime = taskNonRealmObject.dueTime
        self.isImportant = taskNonRealmObject.isImportant
        self.isDone = taskNonRealmObject.isDone
        self.createdAt = taskNonRealmObject.createdAt
    }
}

struct TaskItemNonRealmObject: Equatable {
    var title: String
    var taskDescription: String = ""
    var dueTime: Date
    var isImportant: Bool = false
    var isDone: Bool = false
    var createdAt: Date = .now
    
    init() {
        self.title = ""
        self.taskDescription = ""
        self.dueTime = .now
        self.isImportant = false
        self.isDone = false
        self.createdAt = .now
    }
    
    init(from task: TaskItem) {
        self.title = task.title
        self.taskDescription = task.taskDescription
        self.dueTime = task.dueTime
        self.isImportant = task.isImportant
        self.isDone = task.isDone
        self.createdAt = task.createdAt
    }
}
