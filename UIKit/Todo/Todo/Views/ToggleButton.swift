//
//  ToggleButton.swift
//  Todo
//
//  Created by Le Hoang Anh on 26/02/2022.
//

import UIKit

protocol ToggleButtonDelegate: AnyObject {
    func toggleButtonDidTap(_ toggleButton: ToggleButton)
}

final class ToggleButton: UIView {
    
    // MARK: - Delegation Pattern
    weak var delegate: ToggleButtonDelegate?
    
    
    // MARK: - Initialize Subviews
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        
        return label
    }()
    
    private let switchButton: UISwitch = {
        let switchButton = UISwitch()
        switchButton.translatesAutoresizingMaskIntoConstraints = false
        switchButton.preferredStyle = .sliding
        
        return switchButton
    }()
    
    
    // MARK: - Observed Property
    var title: String? = nil {
        didSet {
            if let title = title {
                titleLabel.text = title
            }
        }
    }
    
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .systemBackground
        layer.cornerRadius = 8
        
        layer.shadowColor = UIColor.systemGray.cgColor
        layer.shadowOffset = .zero
        layer.shadowOpacity = 0.8
        layer.shadowRadius = 2
        
        addSubview(titleLabel)
        addSubview(switchButton)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: switchButton.leadingAnchor, constant: 8),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
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
        delegate?.toggleButtonDidTap(self)
    }
    
    func setOn(_ on: Bool, animated: Bool) {
        switchButton.setOn(on, animated: animated)
    }
    
}
