//
//  DetailCellStyle.swift
//  Todo
//
//  Created by Le Hoang Anh on 28/02/2022.
//

import Foundation

enum DetailCellStyle {
    case toggle(ToggleType)
    case text(TextType)
    case pickerView(PickerViewType)
    
    enum ToggleType {
        case completed
        case important
    }
    
    enum PickerViewType {
        case time
        case date
    }
    
    enum TextType {
        case textField
        case textView
    }
}
