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
}
