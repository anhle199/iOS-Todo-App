//
//  DetailTableViewCell+Delegate.swift
//  Todo
//
//  Created by Le Hoang Anh on 01/03/2022.
//

import Foundation

protocol DetailTableViewCell {
    var cellStyle: DetailCellStyle? { get set }
}

protocol DetailTableViewCellDelegate: AnyObject {
    func detailTableViewCellDidChangeValue(
        _ detailTableView: DetailTableViewCell,
        cellStype type: DetailCellStyle
    )
}
