//
//  TaskDetailViewModel.swift
//  Todo
//
//  Created by Le Hoang Anh on 28/02/2022.
//

import Foundation
import RealmSwift

struct TaskDetailViewModel: DetailBaseViewModelProtocol {
    
    let taskItem: TaskItem
    var draftTaskItem = TaskItemNonRealmObject()
    
    var hasChanges: Bool {
        return draftTaskItem != TaskItemNonRealmObject(from: taskItem)
    }
    
    init(from taskItem: TaskItem) {
        self.taskItem = taskItem
        self.draftTaskItem = .init(from: taskItem)
    }
    
    mutating func commit(completion: ((Bool) -> Void)?) {
        do {
            let realm = try Realm()
            try realm.write {
                taskItem.title = draftTaskItem.title
                taskItem.taskDescription = draftTaskItem.taskDescription
                taskItem.dueTime = draftTaskItem.dueTime
                taskItem.isImportant = draftTaskItem.isImportant
                taskItem.isDone = draftTaskItem.isDone
                taskItem.createdAt = draftTaskItem.createdAt
            }
            
            completion?(true)
        } catch {
            completion?(false)
        }
    }
    
    mutating func rollback(completion: (() -> Void)?) {
        self.draftTaskItem = .init(from: taskItem)
        completion?()
    }
    
}
