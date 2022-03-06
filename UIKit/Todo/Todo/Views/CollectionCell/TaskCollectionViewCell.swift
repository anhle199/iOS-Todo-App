//
//  TaskCollectionViewCell.swift
//  Todo
//
//  Created by Le Hoang Anh on 25/02/2022.
//

import UIKit

protocol TaskCollectionViewCellDelegate: AnyObject {
    func taskCollectionViewCellDidToggleStar(_ cell: TaskCollectionViewCell)
    func taskCollectionViewCellDidToggleCheckmark(_ cell: TaskCollectionViewCell)
}

class TaskCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Identifier
    static let identifier = "TaskCollectionViewCell"
    
    
    // MARK: - Constants
    private static let starIconPointSize: CGFloat = 24
    private static let checkmarkIconPointSize: CGFloat = 28
    private static let defaultDueTimeAsString = "11:59 PM"
    
    
    // MARK: - Initialize Subviews
    private let taskInfoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        stackView.backgroundColor = .clear
        
        return stackView
    }()
    
    private let taskNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .systemBackground
        label.textAlignment = .left
        label.font = .boldSystemFont(ofSize: 24)
        label.numberOfLines = 1
        label.backgroundColor = .clear
        
        return label
    }()
    
    private let taskDescriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .systemBackground.withAlphaComponent(0.5)
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.numberOfLines = 1
        label.backgroundColor = .clear
        
        return label
    }()
    
    private let dueTimeView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        
        return view
    }()
    
    private let dueTimeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .systemBackground
        label.textAlignment = .right
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        label.numberOfLines = 1
        label.backgroundColor = .clear
        
        return label
    }()
    
    private let statusButtonsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        stackView.backgroundColor = .clear
        
        return stackView
    }()
    
    private let starButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(
            UIImage(
                systemName: Constants.IconName.star.unmark,
                withConfiguration: UIImage.SymbolConfiguration.init(
                    pointSize: TaskCollectionViewCell.starIconPointSize
                )
            ),
            for: .normal
        )
        button.tintColor = .systemYellow
        button.backgroundColor = .clear
        
        return button
    }()
    
    private let checkmarkButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(
            UIImage(
                systemName: Constants.IconName.checkmark.unmark,
                withConfiguration: UIImage.SymbolConfiguration.init(
                    pointSize: TaskCollectionViewCell.checkmarkIconPointSize
                )
            ),
            for: .normal
        )
        button.tintColor = .systemBackground
        button.backgroundColor = .clear
        
        return button
    }()
    
    
    // MARK: - Delegation Pattern
    weak var delegate: TaskCollectionViewCellDelegate?

    
    // MARK: - Observed Properties
    var taskNameValue: String = "" {
        didSet { taskNameLabel.text = taskNameValue }
    }
    
    var taskDescriptionValue: String = "" {
        didSet { taskDescriptionLabel.text = taskDescriptionValue }
    }
    
    var dueTimeValue: Date = DateManager.shared.endTime(of: .now) {
        didSet {
            let formatter = DateFormatter()
            formatter.timeStyle = .short
            
            if let timeAsString = formatter.string(for: dueTimeValue) {
                dueTimeLabel.text = (timeAsString.count == 8 ? "" : " ") + timeAsString
            } else {
                dueTimeLabel.text = TaskCollectionViewCell.defaultDueTimeAsString
            }
        }
    }
    
    var isMarkedAsImportant: Bool = false {
        didSet {
            let systemImageName = isMarkedAsImportant
            ? Constants.IconName.star.marked
            : Constants.IconName.star.unmark
           
            starButton.setImage(
                UIImage(
                    systemName: systemImageName,
                    withConfiguration: UIImage.SymbolConfiguration.init(
                        pointSize: TaskCollectionViewCell.starIconPointSize
                    )
                ),
                for: .normal
            )
        }
    }
    
    var isCompletedTask: Bool = false {
        didSet {
            let systemImageName = isCompletedTask
            ? Constants.IconName.checkmark.marked
            : Constants.IconName.checkmark.unmark
            
            checkmarkButton.setImage(
                UIImage(
                    systemName: systemImageName,
                    withConfiguration: UIImage.SymbolConfiguration.init(
                        pointSize: TaskCollectionViewCell.checkmarkIconPointSize
                    )
                ),
                for: .normal
            )
        }
    }
    
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .label
        layer.cornerRadius = 20
        
        setUpSubviews()
        setUpConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Configuration Methods
    private func setUpSubviews() {
        contentView.addSubview(taskInfoStackView)
        contentView.addSubview(dueTimeView)
        contentView.addSubview(statusButtonsStackView)
        
        taskInfoStackView.addArrangedSubview(taskNameLabel)
        taskInfoStackView.addArrangedSubview(taskDescriptionLabel)
        
        dueTimeView.addSubview(dueTimeLabel)
        
        statusButtonsStackView.addArrangedSubview(starButton)
        statusButtonsStackView.addArrangedSubview(checkmarkButton)

        // Bring these buttons in front of its superview
        // in order to can get user's interaction
        starButton.superview?.bringSubviewToFront(starButton)
        checkmarkButton.superview?.bringSubviewToFront(checkmarkButton)

        // Add action for two icon toggle button
        starButton.addTarget(self, action: #selector(didTapStar), for: .touchUpInside)
        checkmarkButton.addTarget(self, action: #selector(didTapCheckmark), for: .touchUpInside)
    }
    
    private func setUpConstraints() {
        let verticalPadding: CGFloat = 8
        let horizontalPadding: CGFloat = 16
        let spacing: CGFloat = 8
        let statusButtonsWidth: CGFloat = 90
        let taskInfoTrailingPadding = spacing + statusButtonsWidth + horizontalPadding
        
        // Constaints
        NSLayoutConstraint.activate([
            // Task info stack view
            taskInfoStackView.topAnchor.constraint(
                equalTo: contentView.topAnchor,
                constant: verticalPadding
            ),
            taskInfoStackView.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: -taskInfoTrailingPadding
            ),
            taskInfoStackView.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor,
                constant: -verticalPadding
            ),
            taskInfoStackView.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: horizontalPadding
            ),
            
            // Due time view
            dueTimeView.topAnchor.constraint(
                equalTo: contentView.topAnchor,
                constant: verticalPadding
            ),
            dueTimeView.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: -horizontalPadding
            ),
            dueTimeView.widthAnchor.constraint(
                equalToConstant: statusButtonsWidth
            ),
            dueTimeView.heightAnchor.constraint(
                equalTo: statusButtonsStackView.heightAnchor
            ),
            
            // Status buttons stack view
            statusButtonsStackView.topAnchor.constraint(
                equalTo: dueTimeView.bottomAnchor,
                constant: -spacing
            ),
            statusButtonsStackView.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: -horizontalPadding
            ),
            statusButtonsStackView.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor,
                constant: -verticalPadding
            ),
            statusButtonsStackView.widthAnchor.constraint(
                equalToConstant: statusButtonsWidth
            ),
            
            // Due time label
            dueTimeLabel.topAnchor.constraint(
                equalTo: dueTimeView.topAnchor
            ),
            dueTimeLabel.trailingAnchor.constraint(
                equalTo: dueTimeView.trailingAnchor,
                constant: -horizontalPadding / 2
            ),
        ])
    }
    
    func makeRoundedCorners(withRadius radius: CGFloat) {
        layer.masksToBounds = true
        layer.cornerRadius = radius
    }
    
    func setDataModel(_ task: TaskItem) {
        taskNameValue = task.title
        taskDescriptionValue = task.taskDescription
        dueTimeValue = task.dueTime
        isMarkedAsImportant = task.isImportant
        isCompletedTask = task.isDone
    }
    
    
    // MARK: - Button Actions
    @objc private func didTapStar() {
        guard let delegate = delegate else {
            return
        }
        
        isMarkedAsImportant.toggle()
        delegate.taskCollectionViewCellDidToggleStar(self)
    }
    
    @objc private func didTapCheckmark() {
        guard let delegate = delegate else {
            return
        }
        
        isCompletedTask.toggle()
        delegate.taskCollectionViewCellDidToggleCheckmark(self)
    }
    
}
