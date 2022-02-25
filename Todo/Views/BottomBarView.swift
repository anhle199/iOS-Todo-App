//
//  BottomBarView.swift
//  Todo
//
//  Created by Le Hoang Anh on 23/02/2022.
//

import UIKit

class BottomBarView: UIView {

    // MARK: - Initialize Subviews
    private let taskCountView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.clipsToBounds = true
        
        return view
    }()
    
    private let taskCountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .label
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        
        return label
    }()
    
    private let selectedDateView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.clipsToBounds = true
        
        return view
    }()
    
    private let selectedDateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .label
        label.textAlignment = .right
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.numberOfLines = 1
        
        return label
    }()
    
    
    // MARK: - Property Observes
    var taskCountValue: String = "" {
        didSet {
            taskCountLabel.text = taskCountValue
        }
    }
    
    var selectedDateValue: Date = .now {
        didSet {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            
            selectedDateLabel.text = formatter.string(for: selectedDateValue)
        }
    }
    
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        backgroundColor = .label.withAlphaComponent(0.2)
        layer.cornerRadius = 16
        
        addSubviews()
        setUpConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Configuration Methods
    private func addSubviews() {
        addSubview(taskCountView)
        addSubview(selectedDateView)
        taskCountView.addSubview(taskCountLabel)
        selectedDateView.addSubview(selectedDateLabel)
    }
    
    private func setUpConstraints() {
        let padding: CGFloat = 10
        let selectedDateViewWidth: CGFloat = 100
        
        // Constraints
        NSLayoutConstraint.activate([
            // Task count view
            taskCountView.topAnchor.constraint(equalTo: topAnchor, constant: padding),
            taskCountView.trailingAnchor.constraint(equalTo: selectedDateLabel.leadingAnchor, constant: -padding),
            taskCountView.bottomAnchor.constraint(equalTo: bottomAnchor),
            taskCountView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            
            // Task count label
            taskCountLabel.topAnchor.constraint(equalTo: taskCountView.topAnchor),
            taskCountLabel.leadingAnchor.constraint(equalTo: taskCountView.leadingAnchor),
            
            // Selected date view
            selectedDateView.topAnchor.constraint(equalTo: topAnchor, constant: padding),
            selectedDateView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            selectedDateView.bottomAnchor.constraint(equalTo: bottomAnchor),
            selectedDateView.widthAnchor.constraint(equalToConstant: selectedDateViewWidth),
            
            // Selected date label
            selectedDateLabel.topAnchor.constraint(equalTo: selectedDateView.topAnchor),
            selectedDateLabel.trailingAnchor.constraint(equalTo: selectedDateView.trailingAnchor),
        ])
    }
    
    func configure(with viewModel: BottomBarViewViewModel) {
        taskCountValue = viewModel.taskCountValue
        selectedDateValue = viewModel.getSelectedDateAndTime()
    }
    
}
