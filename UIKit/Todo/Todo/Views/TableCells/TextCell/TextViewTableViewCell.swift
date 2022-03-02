//
//  TextViewTableViewCell.swift
//  Todo
//
//  Created by Le Hoang Anh on 28/02/2022.
//

import UIKit

class TextViewTableViewCell: UITableViewCell, TextTableViewCell {
    
    // MARK: - Reuse Identifier
    static let identifier = "TextViewTableViewCell"
    
    
    // MARK: - Delegation Pattern
    weak var delegate: TextTableViewCellDelegate?
    
    
    // MARK: - Initialize Subviews
    private let textView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.text = ""
        textView.textAlignment = .left
        textView.font = Constants.SystemTableView.CellView.font
        textView.makeRoundCorners(for: .all, radius: 8)
        textView.isEditable = false
        
        return textView
    }()
    
    
    // MARK: - Stored Properties
    var textValue: String {
        get { textView.text }
        set { self.textView.text = newValue }
    }
    
    var cellStyle: DetailCellStyle?
    
    
    // MARK: - Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(textView)
        
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            textView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            textView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            textView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
        ])
    
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTap))
        textView.addGestureRecognizer(gesture)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    // MARK: - Gesture Action
    @objc private func didTap(_ gesture: UITapGestureRecognizer) {
        delegate?.textTableViewCellShouldDisplayTextEditorPopup(self, cellStype: .textView)
    }
    
    
    // MARK: - Delegate Methods
    func setText(_ text: String, andWantToCallDelegate isCall: Bool) {
        self.textValue = text
        
        if isCall {
            delegate?.detailTableViewCellDidChangeValue(self, cellStype: .text(.textView))
        }
    }
    
}
