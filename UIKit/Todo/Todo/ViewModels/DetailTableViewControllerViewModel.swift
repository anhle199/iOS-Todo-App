//
//  DetailViewControllerViewModel.swift
//  Todo
//
//  Created by Le Hoang Anh on 28/02/2022.
//

import Foundation

struct DetailViewControllerViewModel {
    let taskItem: TaskItem
    
    init(from taskItem: TaskItem) {
        self.taskItem = taskItem
    }
}
