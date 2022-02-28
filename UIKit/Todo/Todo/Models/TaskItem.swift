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


enum TaskState: Int, CaseIterable {
    case uncomplete
    case completed
    case important
}
