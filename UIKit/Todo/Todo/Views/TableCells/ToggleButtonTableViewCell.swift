//
//  ToggleButtonTableViewCell.swift
//  Todo
//
//  Created by Le Hoang Anh on 28/02/2022.
//

import UIKit

class ToggleButtonTableViewCell: UITableViewCell, DetailTableViewCell {

    // MARK: - Reuse Identifier
    static let identifier = "ToggleButtonTableViewCell"
    
    
    // MARK: - Delegation Pattern
    weak var delegate: DetailTableViewCellDelegate?
    
    
    // MARK: - Initialize Subviews
    private let toggleButton: ToggleButton = {
        let toggleButton = ToggleButton()
        toggleButton.translatesAutoresizingMaskIntoConstraints = false
        toggleButton.titleFont = Constants.SystemTableView.CellView.font
        toggleButton.backgroundColor = .clear
        
        return toggleButton
    }()
    
    
    // MARK: - Stored Properties
    var title: String {
        get { toggleButton.title }
        set { self.toggleButton.title = newValue }
    }
    
    var cellStyle: DetailCellStyle?
    
    
    // MARK: - Computed Properties
    var isOn: Bool { toggleButton.isOn }
    
    
    // MARK: - Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(toggleButton)
        
        NSLayoutConstraint.activate([
            toggleButton.topAnchor.constraint(equalTo: contentView.topAnchor),
            toggleButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            toggleButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            toggleButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
        ])
        
        toggleButton.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    // MARK: - Other Methods
    func setOn(_ on: Bool, animated: Bool = false) {
        toggleButton.setOn(on, animated: animated)
    }
    
}


// MARK: - Conforms the ToggleButtonDelegate protocol
extension ToggleButtonTableViewCell: ToggleButtonDelegate {
    func toggleButtonDidChangeValue(_ toggleButton: ToggleButton) {
        guard let type = cellStyle else { return }
        delegate?.detailTableViewCellDidChangeValue(self, cellStype: type)
    }
}
