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
    
    func filterAndSortTasks(from tasks: Results<TaskItem>) {
        let selectedDate = daysOfWeek[selectedDateIndex]
        
        if let predicate = predicate {
            self.displayedTasks = tasks.filter(predicate.predicateFormat)
                .filter { item in
                    Calendar.current.isDate(item.dueTime, inSameDayAs: selectedDate)
                }
                .sorted(by: ascendingTaskItemComparator)
        } else {
            self.displayedTasks = tasks.filter { item in
                Calendar.current.isDate(item.dueTime, inSameDayAs: selectedDate)
            }.sorted(by: ascendingTaskItemComparator)
        }
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
    
//    func createPrecidateFormat(forStates states: [TaskStatus]) -> NSPredicate? {
//        var copiedStates = states
//        
//        // If the 'states' array contains both .uncomplete and .completed, all tasks is satified.
//        if copiedStates.contains(.uncomplete) && copiedStates.contains(.completed) {
//            copiedStates.removeAll(where: { $0 == .uncomplete || $0 == .completed })
//        }
//        
//        var predicateFormat = ""
//        var values = [NSNumber]()
//        
//        if let index = copiedStates.firstIndex(of: .important) {
//            predicateFormat += "isImportant == %@ AND "
//            values.append(.init(booleanLiteral: true))
//            copiedStates.remove(at: index)
//        }
//        
//        if !copiedStates.isEmpty {
//            // copiedStates only contains .uncomplete or .completed
//            
//            let state = copiedStates.first
//            switch state {
//            case .uncomplete:
//                predicateFormat += "isDone <> %@"
//                values.append(.init(booleanLiteral: state == .uncomplete))
//            case .completed:
//                predicateFormat += "isDone == %@"
//                values.append(.init(booleanLiteral: state == .completed))
//            default:
//                break
//            }
//        } else if !predicateFormat.isEmpty {
//            predicateFormat.removeLast(5)  // remove " AND "
//        }
//        
//        if predicateFormat.isEmpty {
//            return nil
//        } else {
//            return NSPredicate(format: predicateFormat, values)
//        }
//    }
    
}
