//
//  HomeViewController.swift
//  Todo
//
//  Created by Le Hoang Anh on 23/02/2022.
//

import UIKit

class HomeViewController: UIViewController {

    // MARK: - Initialize Subviews
    private let dateButtonsHorizontalView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .equalSpacing
        stackView.backgroundColor = .systemBackground
        
        return stackView
    }()
    
    private var dateButtons: [DateButton] = {
        var buttons = [DateButton]()
        
        for i in 0..<HomeViewController.numberOfDateButtons {
            let dateButton = DateButton()
            dateButton.translatesAutoresizingMaskIntoConstraints = false
            dateButton.tag = i
            dateButton.setColors(for: .unselected, withAnimation: false)
            dateButton.makeRoundedCorners(
                withRadius: HomeViewController.dateButtonCornerRadius
            )
            
            buttons.append(dateButton)
        }
        
        return buttons
    }()
    
    private let taskCollectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: UICollectionViewCompositionalLayout(
                sectionProvider: { _, _ in
                    HomeViewController.makeSectionLayout()
                }
            )
        )
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        
        // Register collection view cells
        collectionView.register(
            UICollectionViewCell.self,
            forCellWithReuseIdentifier: "UICollectionViewCell"
        )
        collectionView.register(
            TaskCollectionViewCell.self,
            forCellWithReuseIdentifier: TaskCollectionViewCell.identifier
        )
        
        return collectionView
    }()
    
    private let bottomBarView: BottomBarView = {
        let bottomBarView = BottomBarView()
        bottomBarView.translatesAutoresizingMaskIntoConstraints = false
        
        return bottomBarView
    }()
    
    
    // MARK: - Stored Properties
    private var selectingIndex: Int?
    
    
    // MARK: - Initializers
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        
        setUpNavigationBar()
        setUpDateButtonsView()
        setUpBottomBar()
        setUpTaskListView()
    }
    
    
    // MARK: - View's Configuration Methods
    private func setUpNavigationBar() {
        // Title
        title = "Tasks"

        // Left bar item - filter
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: Constants.IconName.filter),
            style: .plain,
            target: self,
            action: #selector(didTapFilterButton)
        )
        
        // Right bar items - [add, search]
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(
                image: UIImage(systemName: Constants.IconName.search),
                style: .plain,
                target: self,
                action: #selector(didTapSearchButton)
            ),
            UIBarButtonItem(
                image: UIImage(systemName: Constants.IconName.add),
                style: .plain,
                target: self,
                action: #selector(didTapAddButton)
            )
        ]
    }
    
    private func setUpDateButtonsView() {
        var constraints = [NSLayoutConstraint]()
        let shortWeekdaySymbols = Calendar.current.shortWeekdaySymbols
        
        // Add stack view of list of date buttons to view
        view.addSubview(dateButtonsHorizontalView)
        
        // Configure list of date buttons
        for i in 0..<dateButtons.count {
            let dateComponent = Calendar.current.dateComponents(
                in: .current,
                from: HomeViewController.daysOfWeek[i]
            )
            
            dateButtons[i].dayNumberValue = dateComponent.day ?? 1
            dateButtons[i].weekdaySymbolValue = shortWeekdaySymbols[i]
            
            dateButtons[i].addTarget(
                self,
                action: #selector(didTapDateButton),
                for: .touchUpInside
            )
            
            dateButtonsHorizontalView.addArrangedSubview(dateButtons[i])
            
            constraints.append(
                dateButtons[i].widthAnchor.constraint(
                    equalToConstant: HomeViewController.dateButtonSize.width
                )
            )
        }
        
        // Set colors for button (today)
        if let index = HomeViewController.daysOfWeek.firstIndex(
            where: { Calendar.current.isDateInToday($0) }
        ) {
            self.selectingIndex = index
            dateButtons[index].setColors(for: .selecting, withAnimation: false)
        }
        
        // Create constraints for stack view
        let padding: CGFloat = 8
        let safeArea = view.safeAreaLayoutGuide
        constraints.append(contentsOf: [
            dateButtonsHorizontalView.topAnchor.constraint(
                equalTo: safeArea.topAnchor,
                constant: padding
            ),
            dateButtonsHorizontalView.trailingAnchor.constraint(
                equalTo: safeArea.trailingAnchor,
                constant: -padding
            ),
            dateButtonsHorizontalView.leadingAnchor.constraint(
                equalTo: safeArea.leadingAnchor,
                constant: padding
            ),
            dateButtonsHorizontalView.heightAnchor.constraint(
                equalToConstant: HomeViewController.dateButtonSize.height
            ),
        ])
        
        // Active list of constraints
        NSLayoutConstraint.activate(constraints)
    }
    
    private func setUpTaskListView() {
        taskCollectionView.delegate = self
        taskCollectionView.dataSource = self
        
        view.addSubview(taskCollectionView)
        
        NSLayoutConstraint.activate([
            taskCollectionView.topAnchor.constraint(
                equalTo: dateButtonsHorizontalView.bottomAnchor,
                constant: 8
            ),
            taskCollectionView.trailingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.trailingAnchor
            ),
            taskCollectionView.bottomAnchor.constraint(
                equalTo: bottomBarView.topAnchor
            ),
            taskCollectionView.leadingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leadingAnchor
            ),
        ])
    }
    
    private func setUpBottomBar() {
        let selectedDate: Date
        if let index = selectingIndex {
            selectedDate = HomeViewController.daysOfWeek[index]
        } else {
            selectedDate = .now
        }
        
        bottomBarView.taskCountValue = "3 tasks / 1 completed"
        bottomBarView.selectedDateValue = selectedDate
    
        view.addSubview(bottomBarView)
        
        let bottomBarViewHeight: CGFloat = 38
        NSLayoutConstraint.activate([
            bottomBarView.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                constant: -bottomBarViewHeight
            ),
            bottomBarView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomBarView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            bottomBarView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
        ])
    }

    
    // MARK: - Button Actions
    @objc private func didTapFilterButton() {
        print("HomeViewController - didTapFilterButton()")
    }
    
    @objc private func didTapSearchButton() {
        print("HomeViewController - didTapSearchButton()")
    }
    
    @objc private func didTapAddButton() {
        print("HomeViewController - didTapAddButton()")
    }
    
    @objc private func didTapDateButton(_ sender: DateButton) {
        if let selectingIndex = selectingIndex {
            dateButtons[selectingIndex].updateUI(for: .unselected)
        }
        
        self.selectingIndex = sender.tag
        sender.updateUI(for: .selecting)
        bottomBarView.selectedDateValue = HomeViewController.daysOfWeek[sender.tag]
        
        print("HomeViewController - didTapDateButton(_:) - \(selectingIndex!)")
    }
}


// MARK: - Configure Date Buttons
extension HomeViewController {
    
    private static let daysOfWeek = HomeViewController.getDaysOfWeek()
    private static var numberOfDateButtons: Int {
        return HomeViewController.daysOfWeek.count
    }
    
    private static let dateButtonSize = CGSize(width: 40, height: 80)
    private static let dateButtonCornerRadius: CGFloat = 20
    
    private static func getDaysOfWeek() -> [Date] {
        let today = Date()
        let calendar = Calendar.current
        let dayOfWeek = calendar.component(.weekday, from: today)
        let weekdays = calendar.range(of: .weekday, in: .weekOfYear, for: today)
        let days = weekdays?.compactMap { weekday in
            return calendar.date(
                byAdding: .day,
                value: weekday - dayOfWeek,
                to: today
            )
        }
        
        return days ?? []
    }
    
}


// MARK: - Collection View Section Layout
extension HomeViewController {
    
    static func makeSectionLayout() -> NSCollectionLayoutSection {
        let itemHeight: CGFloat = 90
        let spacing: CGFloat = 12
        let padding = spacing
        
        let item = NSCollectionLayoutItem(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalHeight(1)
            )
        )
        
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1),
                heightDimension: .absolute(itemHeight)
            ),
            subitem: item,
            count: 1
        )
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = spacing
        section.contentInsets = .init(top: padding, leading: padding, bottom: padding, trailing: padding)
        
        return section
    }
    
}


// MARK: - Conforms UICollectionViewDataSource
extension HomeViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 9
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: TaskCollectionViewCell.identifier,
            for: indexPath
        ) as? TaskCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.delegate = self
        cell.taskNameValue = "Task name"
        cell.taskDescriptionValue = "A truncated description"
        cell.dueTimeValue = .now
        cell.isMarkedAsImportant = true
        cell.isCompletedTask = false
        
        return cell
    }
    
}


// MARK: - Conform UICollectionViewDelegate and TaskCollectionViewCellDelegate protocol
extension HomeViewController: UICollectionViewDelegate, TaskCollectionViewCellDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        print("HomeViewController - collectionView(_:didSelectItemAt:) - \(indexPath)")
    }
    
    func taskCollectionViewCellDidToggleStar(_ cell: TaskCollectionViewCell) {
        if let indexPath = taskCollectionView.indexPath(for: cell) {
            print("HomeViewController - taskCollectionViewCellDidToggleStar(_:) - \(indexPath)")
        } else {
            print("HomeViewController - taskCollectionViewCellDidToggleStar(_:)")
        }
    }
    
    func taskCollectionViewCellDidToggleCheckmark(_ cell: TaskCollectionViewCell) {
        if let indexPath = taskCollectionView.indexPath(for: cell) {
            print("HomeViewController - taskCollectionViewCellDidToggleCheckmark(_:) - \(indexPath)")
        } else {
            print("HomeViewController - taskCollectionViewCellDidToggleCheckmark(_:)")
        }
    }
    
}
