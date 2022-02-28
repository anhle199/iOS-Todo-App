//
//  FilterView.swift
//  Todo
//
//  Created by Le Hoang Anh on 26/02/2022.
//

import UIKit

protocol FilterViewDelegate: AnyObject {
    func filterViewWillAppear(_ filterView: FilterView)
    func filterViewDidDisappear(_ filterView: FilterView)
    
    func filterViewDidTapClose(_ filterView: FilterView)
    func filterViewDidTapApply(_ filterView: FilterView, withSelectedStates states: [TaskState])
}

final class FilterView: UIView {
    
    // MARK: - Delegation Pattern
    weak var delegate: FilterViewDelegate?
    
    
    // MARK: - Initialize Subviews
    private let dimmingView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.isUserInteractionEnabled = true
        
        return view
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemGray6
        
        return view
    }()
    
    private let titleBarView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemGray3
        
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Filter"
        label.textColor = .label
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 20)
        
        return label
    }()
    
    private let closeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Close", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        button.setTitleColor(.systemBlue, for: .normal)
        
        return button
    }()
    
    private let applyButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Apply", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        button.setTitleColor(.systemBlue, for: .normal)
        button.setTitleColor(.systemGray, for: .disabled)
        button.isEnabled = false
        
        return button
    }()
    
    private let toggleButtonsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 12
        
        return stackView
    }()
    
    private let uncompleteToggleButton: ToggleButton = {
        let toggleButton = ToggleButton()
        toggleButton.title = "Uncomplete"
        toggleButton.tag = TaskState.uncomplete.rawValue
        
        return toggleButton
    }()
    
    private let completedToggleButton: ToggleButton = {
        let toggleButton = ToggleButton()
        toggleButton.title = "Completed"
        toggleButton.tag = TaskState.completed.rawValue
        
        return toggleButton
    }()
    
    private let importantToggleButton: ToggleButton = {
        let toggleButton = ToggleButton()
        toggleButton.title = "Important"
        toggleButton.tag = TaskState.important.rawValue
        
        return toggleButton
    }()
    
    private let noteLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "The default filter values are both Uncomplete and Completed are on."
        label.textColor = .secondaryLabel
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 13, weight: .medium)
        label.numberOfLines = 0
        
        return label
    }()
    
    
    // MARK: - Override Superclass's Property
    override var isHidden: Bool {
        willSet {
            if !newValue {
                delegate?.filterViewWillAppear(self)
            }
        }
        didSet {
            if !isHidden {
                draftTappedToggleButtonTags = tappedToggleButtonTags
            } else {
                delegate?.filterViewDidDisappear(self)
            }
        }
    }
    
    
    // MARK: - Stored Properties
    // This variable determine whether the Apply button is enabled or not
    // and this is also passed to delegate's method to supply for the parent view
    private var tappedToggleButtonTags = Set<Int>()
    private var draftTappedToggleButtonTags = Set<Int>()
    
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .black.withAlphaComponent(0.7)
        
        setUpSubviews()
        setUpConstraints()

        setDefaultFilterValues()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Override Methods
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.roundCorners(for: [.topLeft, .topRight], radius: 24)
    }
    
    
    // MARK: - Configuration Methods
    private func setUpSubviews() {
        // Add subviews
        addSubview(dimmingView)
        addSubview(contentView)
        
        contentView.addSubview(titleBarView)
        contentView.addSubview(toggleButtonsStackView)
        contentView.addSubview(noteLabel)
        
        titleBarView.addSubview(closeButton)
        titleBarView.addSubview(titleLabel)
        titleBarView.addSubview(applyButton)
        
        toggleButtonsStackView.addArrangedSubview(uncompleteToggleButton)
        toggleButtonsStackView.addArrangedSubview(completedToggleButton)
        toggleButtonsStackView.addArrangedSubview(importantToggleButton)
        
        // Add action for buttons and view
        dimmingView.addGestureRecognizer(
            UITapGestureRecognizer(
                target: self,
                action: #selector(didTapClose)
            )
        )
        closeButton.addTarget(self, action: #selector(didTapClose), for: .touchUpInside)
        applyButton.addTarget(self, action: #selector(didTapApply), for: .touchUpInside)
        
        // Apply delegatation pattern
        uncompleteToggleButton.delegate = self
        completedToggleButton.delegate = self
        importantToggleButton.delegate = self
    }
    
    private func setUpConstraints() {
        let titleBarViewHeight: CGFloat = 40
        let barButtonHorizontalPadding: CGFloat = 16
        let spacing: CGFloat = 20
        let horizontalPadding: CGFloat = 12
        let toggleButtonViewHeight: CGFloat = 44
        let bottomSafeArea: CGFloat = 32
        
        NSLayoutConstraint.activate([
            // Dim view
            dimmingView.topAnchor.constraint(equalTo: topAnchor),
            dimmingView.trailingAnchor.constraint(equalTo: trailingAnchor),
            dimmingView.bottomAnchor.constraint(equalTo: contentView.topAnchor),
            dimmingView.leadingAnchor.constraint(equalTo: leadingAnchor),
            
            // Content view
            contentView.trailingAnchor.constraint(
                equalTo: safeAreaLayoutGuide.trailingAnchor
            ),
            contentView.bottomAnchor.constraint(
                equalTo: bottomAnchor
            ),
            contentView.leadingAnchor.constraint(
                equalTo: safeAreaLayoutGuide.leadingAnchor
            ),
            
            // Title bar view
            titleBarView.topAnchor.constraint(
                equalTo: contentView.topAnchor
            ),
            titleBarView.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor
            ),
            titleBarView.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor
            ),
            titleBarView.heightAnchor.constraint(
                equalToConstant: titleBarViewHeight
            ),
            
            // Close button
            closeButton.leadingAnchor.constraint(
                equalTo: titleBarView.leadingAnchor,
                constant: barButtonHorizontalPadding
            ),
            closeButton.centerYAnchor.constraint(
                equalTo: titleBarView.centerYAnchor
            ),

            // Title label
            titleLabel.centerXAnchor.constraint(
                equalTo: titleBarView.centerXAnchor
            ),
            titleLabel.centerYAnchor.constraint(
                equalTo: titleBarView.centerYAnchor
            ),

            // Apply button
            applyButton.trailingAnchor.constraint(
                equalTo: titleBarView.trailingAnchor,
                constant: -barButtonHorizontalPadding
            ),
            applyButton.centerYAnchor.constraint(
                equalTo: titleBarView.centerYAnchor
            ),
            
            // Toggle buttons stack view
            toggleButtonsStackView.topAnchor.constraint(
                equalTo: titleBarView.bottomAnchor,
                constant: spacing
            ),
            toggleButtonsStackView.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: -horizontalPadding
            ),
            toggleButtonsStackView.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: horizontalPadding
            ),
            
            // Height of each toggle button
            uncompleteToggleButton.heightAnchor.constraint(
                equalToConstant: toggleButtonViewHeight
            ),
            
            noteLabel.topAnchor.constraint(
                equalTo: toggleButtonsStackView.bottomAnchor,
                constant: spacing
            ),
            noteLabel.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: -horizontalPadding
            ),
            noteLabel.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor,
                constant: -bottomSafeArea
            ),
            noteLabel.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: horizontalPadding
            ),
        ])
    }
    
    func setDefaultFilterValues() {
        applyButton.isEnabled = false
        
        uncompleteToggleButton.setOn(true, animated: false)
        completedToggleButton.setOn(true, animated: false)
        importantToggleButton.setOn(false, animated: false)
        
        tappedToggleButtonTags.removeAll()
        tappedToggleButtonTags.insert(uncompleteToggleButton.tag)
        tappedToggleButtonTags.insert(completedToggleButton.tag)
        
        applyButton.isEnabled = true
    }
    
    
    // MARK: - Button Actions
    @objc private func didTapClose() {
        isHidden = true
        
        // Rollback state of toggle buttons
        if draftTappedToggleButtonTags != tappedToggleButtonTags {
            tappedToggleButtonTags = draftTappedToggleButtonTags
            
            for state in TaskState.allCases {
                let isOn = tappedToggleButtonTags.contains(state.rawValue)
                
                switch state {
                case .uncomplete:
                    uncompleteToggleButton.setOn(isOn, animated: false)
                case .completed:
                    completedToggleButton.setOn(isOn, animated: false)
                case .important:
                    importantToggleButton.setOn(isOn, animated: false)
                }
            }
            
            applyButton.isEnabled = !tappedToggleButtonTags.isEmpty
        }
        
        delegate?.filterViewDidTapClose(self)
    }
    
    @objc private func didTapApply() {
        applyButton.isEnabled = !tappedToggleButtonTags.isEmpty
        
        let selectedStates = tappedToggleButtonTags.compactMap({ TaskState(rawValue: $0) })
        delegate?.filterViewDidTapApply(self, withSelectedStates: selectedStates)
        
        isHidden = true
    }
    
    func callApplyButtonAction() {
        didTapApply()
    }
    
}


// MARK: - Conforms the ToggleButtonDelegate protocol
extension FilterView: ToggleButtonDelegate {
    func toggleButtonDidTap(_ toggleButton: ToggleButton) {
        if tappedToggleButtonTags.remove(toggleButton.tag) == nil {
            // if the value of remove(_:) function is nil,
            // this toggle button is not tapped yet.
            tappedToggleButtonTags.insert(toggleButton.tag)
        }
        
        applyButton.isEnabled = !tappedToggleButtonTags.isEmpty
    }
}
