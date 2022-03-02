//
//  TextTableViewCell.swift
//  Todo
//
//  Created by Le Hoang Anh on 01/03/2022.
//

import Foundation

protocol TextTableViewCell {
    var textValue: String { get set }
}

protocol TextTableViewCellDelegate: AnyObject {
    func TextTableViewCellDidTap(
        _ textTableView: TextTableViewCell,
        cellStype type: DetailCellStyle.TextType
    )
}
