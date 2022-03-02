//
//  DetailViewControllerViewModel.swift
//  Todo
//
//  Created by Le Hoang Anh on 28/02/2022.
//

import Foundation
import RealmSwift

struct DetailViewControllerViewModel {
    
    let taskItem: TaskItem
    var draftTaskItem: TaskItemNonRealmObject
    
    init(from taskItem: TaskItem) {
        self.taskItem = taskItem
        self.draftTaskItem = .init(from: taskItem)
    }
    
    mutating func commitChanges(completion: ((Bool) -> Void)?) {
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
    
    mutating func rollback() {
        self.draftTaskItem = .init(from: taskItem)
    }
    
}
