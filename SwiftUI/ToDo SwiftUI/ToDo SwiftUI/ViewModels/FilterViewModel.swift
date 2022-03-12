//
//  FilterViewModel.swift
//  ToDo SwiftUI
//
//  Created by Le Hoang Anh on 12/03/2022.
//

import Foundation

class FilterViewModel: ObservableObject {
    @Published var showUncomplete = false
    @Published var showCompleted = false
    @Published var showImportant = false
    
    @Published var selectedStatuses = Set<TaskStatus>()
    
    
    func isDisabledApplyButton(
        withInitialStatuses initialStatuses: Set<TaskStatus>
    ) -> Bool {
        return selectedStatuses.isEmpty || initialStatuses == selectedStatuses
    }
    
    // Reset to initial filter values when pressing the Close button
    func resetFilterValues(withInitialValues initialStatuses: Set<TaskStatus>) {
        for status in initialStatuses {
            let isOn = initialStatuses.contains(status)
            
            switch status {
            case .uncomplete:
                self.showUncomplete = isOn
            case .completed:
                self.showCompleted = isOn
            case .important:
                self.showImportant = isOn
            }
        }
    }
    
    func onValueChanged(with type: TaskStatus) {
        if selectedStatuses.remove(type) == nil {
            selectedStatuses.insert(type)
        }
    }
    
    func createPrecidateFormat() -> NSPredicate? {
        var copiedStates = Array<TaskStatus>(selectedStatuses)
        
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
        
        if predicateFormat.isEmpty {
            return nil
        } else {
            return NSPredicate(format: predicateFormat, argumentArray: values)
        }
    }
    
}
