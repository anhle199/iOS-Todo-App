//
//  TextFieldTableViewCell.swift
//  Todo
//
//  Created by Le Hoang Anh on 28/02/2022.
//

import UIKit

class TextFieldTableViewCell: UITableViewCell, TextTableViewCell {
    
    // MARK: - Reuse Identifier
    static let identifier = "TextFieldTableViewCell"
    
    
    // MARK: - Delegation Pattern
    weak var delegate: TextTableViewCellDelegate?
    
    
    // MARK: - Initialize Subviews
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Constants.SystemTableView.CellView.font
        label.numberOfLines = 1
        
        return label
    }()
    
    private let textField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.text = ""
        textField.textAlignment = .right
        textField.textColor = .secondaryLabel
        textField.font = Constants.SystemTableView.CellView.font
        textField.isEnabled = false

        return textField
    }()
    
    private let pencilIcon: UIImageView = {
        let imageView = UIImageView(image: .init(systemName: "pencil"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = .label
        
        return imageView
    }()
    
    
    // MARK: - Stored Properties
    var title: String {
        get { titleLabel.text ?? ""}
        set { self.titleLabel.text = newValue }
    }
    
    var textValue: String {
        get { textField.text ?? ""}
        set {
            self.pencilIcon.isHidden = !newValue.isEmpty
            self.textField.text = newValue
        }
    }
    
    var cellStyle: DetailCellStyle?
    
    
    // MARK: - Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(textField)
        contentView.addSubview(pencilIcon)

        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.widthAnchor.constraint(equalToConstant: 88),
            
            textField.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 16),
            textField.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            textField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            pencilIcon.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            pencilIcon.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
        ])
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTap))
        contentView.addGestureRecognizer(tapGesture)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    // MARK: - Gesture Action
    @objc private func didTap(_ gesture: UITapGestureRecognizer) {
        delegate?.textTableViewCellShouldDisplayTextEditorPopup(self, cellStype: .textField)
    }
    

    // MARK: - Delegate Methods
    func setText(_ text: String, andWantToCallDelegate isCall: Bool) {
        self.textValue = text
        
        if isCall {
            delegate?.detailTableViewCellDidChangeValue(self, cellStype: .text(.textField))
        }
    }
    
}
