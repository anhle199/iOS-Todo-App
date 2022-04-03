//
//  HomeViewModel.swift
//  Todo
//
//  Created by Le Hoang Anh on 06/03/2022.
//

import UIKit
import RealmSwift

struct HomeViewModel {
    
    private let realm: Realm?
    private var taskItems: Results<TaskItem>?
    var sortedTaskItems = [TaskItem]()  // a sorted array of taskItems
    
    var selectingDateButtonIndex: Int?
    var selectedDate: Date? {
        if let index = selectingDateButtonIndex {
            return DateManager.shared.daysOfWeek[index]
        }
        
        return nil
    }
    
    init() {
        self.realm = try? Realm()
        loadTaskItems()
    }
    
    var countTasks: Int { sortedTaskItems.count }
    
    
    // MARK: - Datebase Manipulation Methods
    mutating func loadTaskItems(withPredicateFormat predicateFormat: String? = nil) {
        guard let index = selectingDateButtonIndex else {
            self.taskItems = nil
            self.sortedTaskItems.removeAll()
            return
        }
        
        let selectedDate = DateManager.shared.daysOfWeek[index]
        let startOfSelectedDate = DateManager.shared.startTime(of: selectedDate)
        let endOfSelectedDate = DateManager.shared.endTime(of: selectedDate)
        
        // Load and filter
        self.taskItems = realm?.objects(TaskItem.self).where {
            $0.dueTime >= startOfSelectedDate && $0.dueTime <= endOfSelectedDate
        }
        
        if let predicateFormat = predicateFormat, !predicateFormat.isEmpty {
            self.taskItems = taskItems?.filter(predicateFormat)
        }
        
        sortTaskItems()
    }
    
    private func ascendingTaskItemComparator(_ lhs: TaskItem, _ rhs: TaskItem) -> Bool {
        // difference of status of completion => uncomplete first
        if lhs.isDone != rhs.isDone {
            return !lhs.isDone
        }
        
        // same due time => important first
        if lhs.dueTime == rhs.dueTime {
            if lhs.isImportant == rhs.isImportant {
                return lhs.createdAt <= rhs.createdAt
            }
            
            return lhs.isImportant
        }
        
        // ascending due time
        return lhs.dueTime < rhs.dueTime
    }
    
    mutating func sortTaskItems() {
        guard let taskItems = taskItems else {
            self.sortedTaskItems.removeAll()
            return
        }
        
        self.sortedTaskItems = taskItems.sorted(by: ascendingTaskItemComparator)
    }
    
    mutating func filterCurrentTaskItems(
        byTitle title: String,
        andSortInAscendingOrder isSortInAscending: Bool = true
    ) {
        guard let taskItems = taskItems else {
            self.sortedTaskItems.removeAll()
            return
        }
        
        self.sortedTaskItems = taskItems.filter { item in
            item.title.localizedCaseInsensitiveContains(title)
        }
        
        if isSortInAscending {
            self.sortedTaskItems.sort(by: ascendingTaskItemComparator)
        }
    }
    
    mutating func removeTaskItem(at index: Int) -> Bool {
        guard let realm = realm,
              let index = taskItems?.firstIndex(where: {
                  $0.createdAt == sortedTaskItems[index].createdAt
              })
        else {
            return false
        }
        
        do {
            try realm.write {
                realm.delete(taskItems![index])
            }
            
            return true
        } catch {
            return false
        }
    }
    
    func index(
        of taskItem: TaskItem,
        inOriginalTasks isInOriginalTasks: Bool = false
    ) -> Int? {
        if isInOriginalTasks {
            return taskItems?.firstIndex(where: { $0.createdAt == taskItem.createdAt })
        } else {
            return sortedTaskItems.firstIndex(where: { $0.createdAt == taskItem.createdAt })
        }
    }
    
    func getTaskItem(
        at index: Int,
        inOriginalTasks isInOriginalTasks: Bool = false
    ) -> TaskItem? {
        if isInOriginalTasks {
            return taskItems?[index]
        } else {
            return sortedTaskItems[index]
        }
    }
    
    func getTaskItemInOriginalTasks(_ taskItem: TaskItem) -> TaskItem? {
        guard let index = index(of: taskItem, inOriginalTasks: true) else {
            return nil
        }
        
        return taskItems?[index]
    }
    
    enum StatusCanUpdate {
        case important, completetion
    }
    
    func toggleStatus(_ status: StatusCanUpdate, of taskItem: TaskItem) -> Bool {
        guard let index = index(of: taskItem, inOriginalTasks: true) else {
            return false
        }
        
        return toggleStatusOfTaskItem(
            forStatus: status,
            at: index,
            inOriginalTasks: true
        )
    }
    
    func toggleStatusOfTaskItem(
        forStatus status: StatusCanUpdate,
        at index: Int,
        inOriginalTasks isInOriginalTasks: Bool = false
    ) -> Bool {
        guard let realm = realm else { return false }
        
        var indexInOriginalTasks = index
        if !isInOriginalTasks {
            if let index = self.index(of: sortedTaskItems[index], inOriginalTasks: true) {
                indexInOriginalTasks = index
            } else {
                return false
            }
        }
        
        do {
            try realm.write {
                switch status {
                case .important:
                    taskItems![indexInOriginalTasks].isImportant.toggle()
                case .completetion:
                    taskItems![indexInOriginalTasks].isDone.toggle()
                }
            }
            
            return true
        } catch {
            return false
        }
    }
    
    func getBottomBarDisplayedValue() -> (
        totalTasks: Int,
        completedTasks: Int,
        selectedDate: Date?
    ) {
        if let index = selectingDateButtonIndex, !sortedTaskItems.isEmpty {
            return (
                totalTasks: sortedTaskItems.count,
                completedTasks: sortedTaskItems.filter({ $0.isDone }).count,
                DateManager.shared.daysOfWeek[index]
            )
        }
        
        return (totalTasks: 0, completedTasks: 0, selectedDate: nil)
    }
    
    func createPrecidateFormat(forStates states: [TaskState]) -> (predicateFormat: String, values: [NSNumber]) {
        var copiedStates = states
        
        // If the 'states' array contains both .uncomplete and .completed, all tasks is satified.
        if copiedStates.contains(.uncomplete) && copiedStates.contains(.completed) {
            copiedStates.removeAll(where: { $0 == .uncomplete || $0 == .completed })
        }
        
        var predicateFormat = ""
        var values = [NSNumber]()
        
        if let index = copiedStates.firstIndex(of: .important) {
            predicateFormat += "isImportant == %@ AND "
            values.append(.init(booleanLiteral: true))
            copiedStates.remove(at: index)
        }
        
        if !copiedStates.isEmpty {
            // copiedStates only contains .uncomplete or .completed
            
            let state = copiedStates.first
            switch state {
            case .uncomplete:
                predicateFormat += "isDone <> %@"
                values.append(.init(booleanLiteral: state == .uncomplete))
            case .completed:
                predicateFormat += "isDone == %@"
                values.append(.init(booleanLiteral: state == .completed))
            default:
                break
            }
        } else if !predicateFormat.isEmpty {
            predicateFormat.removeLast(5)  // remove " AND "
        }
        
        return (predicateFormat, values)
    }
    
}
