//
//  HomeViewModel.swift
//  ToDo SwiftUI
//
//  Created by Le Hoang Anh on 11/03/2022.
//

import Foundation
import RealmSwift

class HomeViewModel: ObservableObject {
    
    @Published var daysOfWeek = DateManager.shared.daysOfWeek
    @Published var selectedDateIndex = 0
    @Published var displayedTasks = [TaskItem]()
    @Published var isValueChanged = false
    @Published var predicate: NSPredicate? = nil
    @Published var searchButtonClicked = false
    @Published var needsToResetDateIndex = true
    
    var countTasks: Int { displayedTasks.count }
    var countDates: Int { daysOfWeek.count }
    
    var indexOfTodayInWeek: Int? {
        return daysOfWeek.firstIndex { date in
            Calendar.current.isDateInToday(date)
        }
    }
    
    var selectedDate: Date { daysOfWeek[selectedDateIndex] }
    
    func reloadDaysOfWeek() {
        self.daysOfWeek = DateManager.getDaysOfWeek()
        self.resetDateIndexToToday()
    }
    
    func resetDateIndexToToday() {
        self.selectedDateIndex = indexOfTodayInWeek ?? 0
    }
    
    func filterAndSortTasks(
        from tasks: Results<TaskItem>,
        containsTaskTitle title: String? = nil
    ) {
        var tasksFilteredByPredicate = tasks
        if let predicate = predicate {
            tasksFilteredByPredicate = tasks.filter(predicate.predicateFormat)
        }
        
        let selectedDate = daysOfWeek[selectedDateIndex]
        self.displayedTasks = tasksFilteredByPredicate.filter { item in
            let isSameDay = Calendar.current.isDate(
                item.dueTime,
                inSameDayAs: selectedDate
            )
            
            var filterByTitleResult = true
            if let title = title {
                filterByTitleResult = item.title
                    .localizedCaseInsensitiveContains(title)
            }
            
            return isSameDay && filterByTitleResult
        }
        .sorted(by: ascendingTaskItemComparator)
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
    
    var taskCountStatWithFormatting: String {
        let totalTasks = displayedTasks.count
        let completedTasksCount = displayedTasks.filter({ $0.isDone }).count
        
        return totalTasks == 0 ? "No tasks" : "\(totalTasks) tasks / \(completedTasksCount) completed"
    }
    
    var dateFormatterInMediumStyle: DateFormatter {
        DateManager.shared.getDateFormatter(withDateStyle: .medium)
    }
    
}
