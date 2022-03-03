//
//  Constants.swift
//  Todo
//
//  Created by Le Hoang Anh on 25/02/2022.
//

import UIKit

struct Constants {
    
    struct IconName {
        static let filter = "slider.horizontal.3"
        static let search = "magnifyingglass"
        static let add = "plus"
        static let star = (unmark: "star", marked: "star.fill")
        static let checkmark = (
            unmark: "square.fill",
            marked: "checkmark.square.fill"
        )
    }
    
    struct DetailTableView {
        static let numberOfRowsInEachSection = [1, 2, 2, 1]
        static let numberOfSections = numberOfRowsInEachSection.count
        static let dueTimeSection = 2
        
        static let titleForHeaderInSections = [
            "STATUS",
            "BASIC",
            "DUE DATE",
            "DESCRIPTION",
        ]
        static let titleForFooterInSections = [
            "",
            "Click on text value of task name to open text editor for that.",
            "This task will only take place this week.",
            "Click on any position of description text or white space to open text editor for that.",
        ]
        
        static let cellStyles: [[DetailCellStyle]] = [
            [ .toggle(.completed) ],
            [ .text(.textField), .toggle(.important) ],
            [ .pickerView(.time), .pickerView(.date) ],
            [ .text(.textView) ]
        ]
        
        static let heightForRowInSections: [CGFloat] = [44, 44, 44, 200]
    }
    
    struct CreateTaskTableView {
        static let numberOfRowsInEachSection = [2, 2, 1]
        static let numberOfSections = numberOfRowsInEachSection.count
        static let dueTimeSection = 1
        
        static let titleForHeaderInSections = [
            "BASIC",
            "DUE DATE",
            "DESCRIPTION",
        ]
        static let titleForFooterInSections = [
            "Click on text value of task name to open text editor for that.",
            "This task will only take place selected week.",
            "Click on any position of description text or white space to open text editor for that.",
        ]
        
        static let cellStyles: [[DetailCellStyle]] = [
            [ .text(.textField), .toggle(.important) ],
            [ .pickerView(.time), .pickerView(.date) ],
            [ .text(.textView) ]
        ]
        
        static let heightForRowInSections: [CGFloat] = [44, 44, 200]
    }
    
    struct SystemTableView {
        struct HeaderFooterView {
            static let textColor = UIColor.secondaryLabel
            static let font = UIFont.preferredFont(forTextStyle: .footnote).withSize(13)
        }
        struct CellView {
            static let textColor = UIColor.label
            static let font = UIFont.preferredFont(forTextStyle: .body).withSize(17)
        }
    }
    
}
