//
//  ToggleButton.swift
//  Todo
//
//  Created by Le Hoang Anh on 26/02/2022.
//

import UIKit

protocol ToggleButtonDelegate: AnyObject {
    func toggleButtonDidChangeValue(_ toggleButton: ToggleButton)
}

final class ToggleButton: UIView {
    
    // MARK: - Delegation Pattern
    weak var delegate: ToggleButtonDelegate?
    
    
    // MARK: - Initialize Subviews
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Toggle"
        label.font = .systemFont(ofSize: 17)
        label.textAlignment = .left
        label.numberOfLines = 1
        
        return label
    }()
    
    private let switchButton: UISwitch = {
        let switchButton = UISwitch()
        switchButton.translatesAutoresizingMaskIntoConstraints = false
        switchButton.preferredStyle = .sliding
        
        return switchButton
    }()
    
    
    // MARK: - Stored Property
    var title: String {
        get { titleLabel.text ?? "" }
        set { self.titleLabel.text = newValue }
    }
    
    var titleFont: UIFont {
        get { titleLabel.font }
        set { self.titleLabel.font = newValue }
    }
    
    var isOn: Bool {
        get { switchButton.isOn }
        set { setOn(newValue, animated: false) }
    }
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .systemBackground
        
        addSubview(titleLabel)
        addSubview(switchButton)
        
        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: switchButton.leadingAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            
            switchButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            switchButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
        ])
        
        switchButton.addTarget(self, action: #selector(didTap), for: .valueChanged)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Button Actions
    @objc private func didTap() {
        delegate?.toggleButtonDidChangeValue(self)
    }
    
    func setOn(_ on: Bool, animated: Bool) {
        switchButton.setOn(on, animated: animated)
    }

}
