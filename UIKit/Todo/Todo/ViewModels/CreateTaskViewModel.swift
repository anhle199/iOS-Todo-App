//
//  CreateTaskViewModel.swift
//  Todo
//
//  Created by Le Hoang Anh on 03/03/2022.
//

import Foundation
import RealmSwift

struct CreateTaskViewModel: DetailBaseViewModelProtocol {
    
    var dueTime: Date
    var draftTaskItem: TaskItemNonRealmObject
    private let emptyTaskItem: TaskItemNonRealmObject
    
    var hasChanges: Bool {
        return draftTaskItem != emptyTaskItem
    }
    
    init(dueTime: Date) {
        self.dueTime = DateManager.shared.endTime(of: dueTime)
        self.draftTaskItem = TaskItemNonRealmObject()
        self.draftTaskItem.dueTime = self.dueTime
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
        self.draftTaskItem.dueTime = self.dueTime
        completion?()
    }
    
}
