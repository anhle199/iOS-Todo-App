//
//  HomeViewController.swift
//  Todo
//
//  Created by Le Hoang Anh on 23/02/2022.
//

import UIKit
import RealmSwift

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
        
        // Register collection view cell
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
    
    private let filterView: FilterView = {
        let filterView = FilterView()
        filterView.translatesAutoresizingMaskIntoConstraints = false
        filterView.isHidden = true

        return filterView
    }()
    
    private let connectionAlertVC: UIAlertController = {
        let alert = UIAlertController(
            title: "Connection",
            message: "Your connection is unstable or disconnected.",
            preferredStyle: .alert
        )
        
        let closeAction = UIAlertAction(title: "Close", style: .default, handler: nil)
        alert.addAction(closeAction)
        
        return alert
    }()
    
    
    // MARK: - Stored Properties
    private let realm = try! Realm()
    private var taskItems: Results<TaskItem>?
    private var sortedTaskItems = [TaskItem]()  // a sorted array of taskItems
    
    private var selectingDateButtonIndex: Int?

    
    // MARK: - View Controller's Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        
        setUpNavigationBar()
        setUpDateButtonsView()
        setUpBottomBar()
        setUpTaskListView()
        setUpFilterView()
        
        loadTaskItems()
        updateBottomBar()
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
//        shortWeekdaySymbols.append(shortWeekdaySymbols.remove(at: 0))
        
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
            self.selectingDateButtonIndex = index
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
        updateBottomBar()
    
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
    
    private func setUpFilterView() {
        filterView.delegate = self
        
        view.addSubview(filterView)
        
        NSLayoutConstraint.activate([
            filterView.topAnchor.constraint(equalTo: view.topAnchor),
            filterView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            filterView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            filterView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
        ])
    }
    
    
    // MARK: - UI Modification Methods
    private func updateBottomBar() {
        guard let selectingIndex = selectingDateButtonIndex,
              taskItems != nil
        else {
            bottomBarView.selectedDateValue = .now
            bottomBarView.taskCountValue = "No tasks"
            return
        }
        
        bottomBarView.selectedDateValue = HomeViewController.daysOfWeek[selectingIndex]
        
        if sortedTaskItems.isEmpty {
            bottomBarView.taskCountValue = "No tasks"
        } else {
            let completedTaskCount = sortedTaskItems.filter({ $0.isDone }).count
            bottomBarView.taskCountValue = "\(sortedTaskItems.count) tasks / \(completedTaskCount) completed"
        }
    }

    
    // MARK: - Button Actions
    @objc private func didTapFilterButton() {
        filterView.isHidden = false
    }
    
    @objc private func didTapSearchButton() {
        print("HomeViewController - didTapSearchButton()")
    }
    
    @objc private func didTapAddButton() {
        print("HomeViewController - didTapAddButton()")
    }
    
    @objc private func didTapDateButton(_ sender: DateButton) {
        filterView.setDefaultFilterValues()
        
        if let selectingDateButtonIndex = selectingDateButtonIndex {
            dateButtons[selectingDateButtonIndex].updateUI(for: .unselected)
        }
        
        self.selectingDateButtonIndex = sender.tag
        sender.updateUI(for: .selecting)
    
        loadTaskItems()
        updateBottomBar()
    }
    
}


// MARK: - Datebase Manipulation Methods
extension HomeViewController {
    func loadTaskItems(withPredicateFormat predicateFormat: String? = nil) {
        let selectedDate: Date
        if selectingDateButtonIndex != nil {
            selectedDate = HomeViewController.daysOfWeek[selectingDateButtonIndex!]
        } else {
            selectedDate = .now
        }
        
        let startOfSelectedDate = Date.getStartOfDate(from: selectedDate)
        let endOfSelectedDate = Date.getEndOfDate(from: selectedDate)
        
        // Load and filter
        taskItems = realm.objects(TaskItem.self).where {
            $0.dueTime >= startOfSelectedDate && $0.dueTime <= endOfSelectedDate
        }
        
        if let predicateFormat = predicateFormat {
            self.taskItems = taskItems?.filter(predicateFormat)
        }
        
        sortTaskItems()
        taskCollectionView.reloadData()
    }
    
    private func sortTaskItems() {
        guard let taskItems = taskItems else {
            return
        }
        
        sortedTaskItems = taskItems.sorted { lhs, rhs in
            // difference of status of completion => uncomplete first
            if lhs.isDone != rhs.isDone {
                return !lhs.isDone
            }
            
            // same due time => important first
            if lhs.dueTime == rhs.dueTime {
                if lhs.isImportant == rhs.isImportant {
                    return lhs.createdAt <= rhs.createdAt
                }
                
                return lhs.isImportant
            }
            
            // ascending due time
            return lhs.dueTime < rhs.dueTime
        }
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
                value: weekday - dayOfWeek,  // + 1,  // starts from Monday
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
        return taskItems?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let _ = taskItems,
              let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: TaskCollectionViewCell.identifier,
                for: indexPath
              ) as? TaskCollectionViewCell
        else {
            return UICollectionViewCell()
        }
        
        cell.delegate = self
        cell.setDataModel(sortedTaskItems[indexPath.row])
        
        return cell
    }
    
}


// MARK: - Conform UICollectionViewDelegate and TaskCollectionViewCellDelegate protocol
extension HomeViewController: UICollectionViewDelegate, TaskCollectionViewCellDelegate {
    
    private func index(of taskItem: TaskItem) -> Int? {
        return taskItems?.firstIndex(where: { $0.createdAt == taskItem.createdAt })
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)

        if  let index = index(of: sortedTaskItems[indexPath.row]) {
            
            let detailVC = DetailViewController(taskItem: taskItems![index])
            detailVC.valueChangedDidSave = {
                // Because taskItems is auto updating,
                // so we don't have to call loadTaskItems() methods.
                self.sortTaskItems()
                self.taskCollectionView.reloadData()
                self.updateBottomBar()
            }
            
            navigationController?.pushViewController(detailVC, animated: true)
        }
    }
    
    func taskCollectionViewCellDidToggleStar(_ cell: TaskCollectionViewCell) {
        guard let indexPath = taskCollectionView.indexPath(for: cell),
              let taskItemIndex = index(of: sortedTaskItems[indexPath.row])
        else {
            return
        }
        
        do {
            try realm.write {
                taskItems![taskItemIndex].isImportant.toggle()
            }
            
            filterView.callApplyButtonAction()
        } catch {
            self.present(connectionAlertVC, animated: true)
        }
    }
    
    func taskCollectionViewCellDidToggleCheckmark(_ cell: TaskCollectionViewCell) {
        guard let indexPath = taskCollectionView.indexPath(for: cell),
              let taskItemIndex = index(of: sortedTaskItems[indexPath.row])
        else {
            return
        }
        
        do {
            try realm.write {
                taskItems![taskItemIndex].isDone.toggle()
            }
            
            filterView.callApplyButtonAction()
        } catch {
            self.present(connectionAlertVC, animated: true)
        }
    }
    
}


// MARK: - Conforms FilterViewDelegate
extension HomeViewController: FilterViewDelegate {
    
    func filterViewWillAppear(_ filterView: FilterView) {
        navigationController?.navigationBar.isUserInteractionEnabled = false
        bottomBarView.isHidden = true
    }
    
    func filterViewDidDisappear(_ filterView: FilterView) {
        navigationController?.navigationBar.isUserInteractionEnabled = true
        bottomBarView.isHidden = false
    }
    
    func filterViewDidTapApply(_ filterView: FilterView, withSelectedStates states: [TaskState]) {
        var copiedStates = states
        
        // If the 'states' array contains both .uncomplete and .completed, all tasks is satified.
        if copiedStates.contains(.uncomplete) && copiedStates.contains(.completed) {
            copiedStates.removeAll(where: { $0 == .uncomplete || $0 == .completed })
        }
        
        var predicateFormat = ""
        var values = [NSNumber]()
        
        if let index = copiedStates.firstIndex(of: .important) {
            predicateFormat += "isImportant == %@ AND "
            values.append(.init(booleanLiteral: true))
            copiedStates.remove(at: index)
        }
        
        if !copiedStates.isEmpty {
            // copiedStates only contains .uncomplete or .completed
            
            let state = copiedStates.first
            switch state {
                case .uncomplete:
                    predicateFormat += "isDone <> %@"
                    values.append(.init(booleanLiteral: state == .uncomplete))
                case .completed:
                    predicateFormat += "isDone == %@"
                    values.append(.init(booleanLiteral: state == .completed))
                default:
                    break
                }
        } else if !predicateFormat.isEmpty {
            predicateFormat.removeLast(5)  // remove " AND "
        }
        
        if predicateFormat.isEmpty {
            loadTaskItems()
        } else {
            let predicate = NSPredicate(
                format: predicateFormat,
                argumentArray: values
            )
            loadTaskItems(withPredicateFormat: predicate.predicateFormat)
        }
        
        updateBottomBar()
        bottomBarView.isHidden = false
        
//        var copiedStates = states
//        var predicateFormat = ""
//        var values = [NSNumber]()
//
//        if let index = copiedStates.firstIndex(of: .important) {
//            predicateFormat += "isImportant == %@ AND "
//            values.append(.init(booleanLiteral: true))
//            copiedStates.remove(at: index)
//        }
//
//        if !copiedStates.isEmpty {
//            var subPredicateFormat = ""
//
//            for state in copiedStates {
//                switch state {
//                case .uncomplete:
//                    subPredicateFormat += "isDone <> %@ OR "
//                    values.append(.init(booleanLiteral: state == .uncomplete))
//                case .completed:
//                    subPredicateFormat += "isDone == %@ OR "
//                    values.append(.init(booleanLiteral: state == .completed))
//                default:
//                    break
//                }
//            }
//
//            subPredicateFormat.removeLast(4)  // remove " OR "
//            predicateFormat += "(\(subPredicateFormat))"
//        } else if !predicateFormat.isEmpty {
//            predicateFormat.removeLast(5)  // remove " AND "
//        }
//
//        let predicate = NSPredicate(
//            format: predicateFormat,
//            argumentArray: values
//        )
//        loadTaskItems(withPredicateFormat: predicate.predicateFormat)
//
//        updateBottomBar()
//        bottomBarView.isHidden = false
    }
    
}
