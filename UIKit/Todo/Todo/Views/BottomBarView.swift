//
//  BottomBarView.swift
//  Todo
//
//  Created by Le Hoang Anh on 23/02/2022.
//

import UIKit

class BottomBarView: UIView {

    // MARK: - Initialize Subviews
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .label.withAlphaComponent(0.2)
        view.makeRoundCorners(for: [.topLeft, .topRight], radius: 20)
        
        return view
    }()
    
    private let taskCountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "No tasks"
        label.textColor = .label
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        label.clipsToBounds = true
        
        return label
    }()
    
    private let selectedDateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .label
        label.textAlignment = .right
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.numberOfLines = 1
        label.clipsToBounds = true
        
        return label
    }()
    
    
    func setTaskCountValue(totalTasks: Int, completedTasks: Int) {
        if totalTasks == 0 {
            taskCountLabel.text = "No tasks"
        } else {
            taskCountLabel.text = "\(totalTasks) tasks / \(completedTasks) completed"
        }
    }
    
    
    // MARK: - Observed Properties
    var selectedDateValue: Date? = nil {
        didSet {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            
            selectedDateLabel.text = formatter.string(for: selectedDateValue) ?? "Unknown"
        }
    }
    
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        addSubviews()
        setUpConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Configuration Methods
    private func addSubviews() {
        addSubview(contentView)
        contentView.addSubview(taskCountLabel)
        contentView.addSubview(selectedDateLabel)
    }
    
    private func setUpConstraints() {
        let padding: CGFloat = 10
        let selectedDateViewWidth: CGFloat = 100

        // Constraints
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            
            taskCountLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
            taskCountLabel.trailingAnchor.constraint(equalTo: selectedDateLabel.leadingAnchor, constant: -padding),
            taskCountLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            
            selectedDateLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
            selectedDateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            selectedDateLabel.widthAnchor.constraint(equalToConstant: selectedDateViewWidth),
        ])
    }
    
}
