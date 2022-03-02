//
//  TextTableViewCell+Delegate.swift
//  Todo
//
//  Created by Le Hoang Anh on 02/03/2022.
//

import Foundation

protocol TextTableViewCell: DetailTableViewCell {
    var textValue: String { get set }
    
    func setText(_ text: String, andWantToCallDelegate isCall: Bool)
}

protocol TextTableViewCellDelegate: DetailTableViewCellDelegate {
    func textTableViewCellShouldDisplayTextEditorPopup(
        _ textTableView: TextTableViewCell,
        cellStype type: DetailCellStyle.TextType
    )
}
