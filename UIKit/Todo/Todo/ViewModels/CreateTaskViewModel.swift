//
//  CreateTaskViewModel.swift
//  Todo
//
//  Created by Le Hoang Anh on 03/03/2022.
//

import Foundation
import RealmSwift

struct CreateTaskViewModel: DetailBaseViewModelProtocol {
    
    var draftTaskItem: TaskItemNonRealmObject
    private let emptyTaskItem: TaskItemNonRealmObject
    
    var hasChanges: Bool {
        return draftTaskItem != emptyTaskItem
    }
    
    init() {
        self.draftTaskItem = TaskItemNonRealmObject()
        self.emptyTaskItem = draftTaskItem
    }
    
    mutating func commit(completion: ((Bool) -> Void)?) {
        do {
            let realm = try Realm()
            try realm.write {
                let taskItem = TaskItem()
                taskItem.title = draftTaskItem.title
                taskItem.taskDescription = draftTaskItem.taskDescription
                taskItem.dueTime = draftTaskItem.dueTime
                taskItem.isImportant = draftTaskItem.isImportant
                taskItem.isDone = draftTaskItem.isDone
                taskItem.createdAt = .now
                
                realm.add(taskItem)
            }
            
            completion?(true)
        } catch {
            completion?(false)
        }
    }
    
    mutating func rollback(completion: (() -> Void)?) {
        self.draftTaskItem = TaskItemNonRealmObject()
        completion?()
    }
    
}
