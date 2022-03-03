//
//  DetailBaseViewModel.swift
//  Todo
//
//  Created by Le Hoang Anh on 04/03/2022.
//

import Foundation

protocol DetailBaseViewModelProtocol {
    var draftTaskItem: TaskItemNonRealmObject { get set }
    var hasChanges: Bool { get }
    
    mutating func commit(completion: ((Bool) -> Void)?)
    mutating func rollback(completion: (() -> Void)?)
}

struct DetailBaseViewModel: DetailBaseViewModelProtocol {
    var draftTaskItem = TaskItemNonRealmObject()
    var hasChanges: Bool {
        return false
    }
    
    mutating func commit(completion: ((Bool) -> Void)?) {
        
    }
    
    mutating func rollback(completion: (() -> Void)?) {
        
    }
}
