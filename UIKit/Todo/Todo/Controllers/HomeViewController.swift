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
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.searchBarStyle = .minimal
        searchBar.autocapitalizationType = .none
        searchBar.placeholder = "Type task name here..."
        searchBar.autocorrectionType = .no
        searchBar.isHidden = true
        searchBar.showsCancelButton = true

        return searchBar
    }()

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
    
    private let loadingView: LoadingView = {
        let loadingView = LoadingView()
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        
        return loadingView
    }()
    
    private let collectionView: UICollectionView = {
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
        collectionView.isHidden = true
        
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
    
    
    // MARK: - View Model
    private var viewModel = HomeViewModel()
    
    
    // MARK: - Stored Properties
    private var dateButtonsHorizontalViewTopAnchorConstraintsIfSearchBarIsHidden: NSLayoutConstraint!
    private var dateButtonsHorizontalViewTopAnchorConstraintsIfSearchBarIsShown: NSLayoutConstraint!
    
    
    // MARK: - View Controller's Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        
        setUpNavigationBar()
        setUpSearchBar()
        setUpDateButtonsView()
        setUpBottomBar()
        
        setUpLoadingView()
        startLoadingAnimation()
        
        setUpTaskListView()
        setUpFilterView()
        
        viewModel.loadTaskItems()
        collectionView.reloadData()
        updateBottomBar()
        
        endLoadingAnimation()
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
    
    private func setUpSearchBar() {
        searchBar.delegate = self
        
        view.addSubview(searchBar)

        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
        ])
    }
    
    private func setUpDateButtonsView() {
        var constraints = [NSLayoutConstraint]()
        var shortWeekdaySymbols = Calendar.current.shortWeekdaySymbols
        shortWeekdaySymbols.append(shortWeekdaySymbols.remove(at: 0))
        
        // Add stack view of list of date buttons to view
        view.addSubview(dateButtonsHorizontalView)
        
        // Configure list of date buttons
        for i in 0..<dateButtons.count {
            let dateComponent = Calendar.current.dateComponents(
                in: .current,
                from: DateManager.shared.daysOfWeek[i]
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
        if let index = DateManager.shared.daysOfWeek.firstIndex(
            where: { Calendar.current.isDateInToday($0) }
        ) {
            viewModel.selectingDateButtonIndex = index
            dateButtons[index].setColors(for: .selecting, withAnimation: false)
        }
        
        // Create constraints for stack view
        let padding: CGFloat = 8
        let safeArea = view.safeAreaLayoutGuide
        
        self.dateButtonsHorizontalViewTopAnchorConstraintsIfSearchBarIsHidden = dateButtonsHorizontalView.topAnchor.constraint(
            equalTo: safeArea.topAnchor,
            constant: padding
        )
        self.dateButtonsHorizontalViewTopAnchorConstraintsIfSearchBarIsShown = dateButtonsHorizontalView.topAnchor.constraint(
            equalTo: searchBar.bottomAnchor,
            constant: padding
        )
        
        constraints.append(contentsOf: [
            dateButtonsHorizontalViewTopAnchorConstraintsIfSearchBarIsHidden,
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
    
    private func setUpLoadingView() {
        view.addSubview(loadingView)
        
        NSLayoutConstraint.activate([
            loadingView.topAnchor.constraint(equalTo: dateButtonsHorizontalView.topAnchor),
            loadingView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            loadingView.bottomAnchor.constraint(equalTo: bottomBarView.topAnchor),
            loadingView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
        ])
    }
    
    private func setUpTaskListView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        
        // Add long press gesture for each cell of task collection view
        collectionView.addGestureRecognizer(
            UILongPressGestureRecognizer(
                target: self,
                action: #selector(didTapLongPressOnCollectionViewCell)
            )
        )
        
        
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(
                equalTo: dateButtonsHorizontalView.bottomAnchor,
                constant: 8
            ),
            collectionView.trailingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.trailingAnchor
            ),
            collectionView.bottomAnchor.constraint(
                equalTo: bottomBarView.topAnchor
            ),
            collectionView.leadingAnchor.constraint(
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
        let (totalTasks, completedTasks, selectedDate) = viewModel.getBottomBarDisplayedValue()
        bottomBarView.selectedDateValue = selectedDate
        bottomBarView.setTaskCountValue(totalTasks: totalTasks, completedTasks: completedTasks)
    }

    func reloadData() {
        startLoadingAnimation()
        
        if !searchBar.isHidden {
            searchBar(searchBar, textDidChange: searchBar.text ?? "")
        } else {
            filterView.callApplyButtonAction()
        }
        
        endLoadingAnimation()
    }
    
    func startLoadingAnimation() {
        collectionView.isHidden = true
        loadingView.startAnimating()
    }
    
    func endLoadingAnimation() {
        loadingView.endAnimating()
        collectionView.isHidden = false
    }
    
    
    // MARK: - Button Actions
    @objc private func didTapFilterButton() {
        filterView.isHidden = false
    }
    
    @objc private func didTapSearchButton() {
        navigationController?.isNavigationBarHidden = true
        searchBar.isHidden = false
        updateConstraints(forHidingSearchBar: false)
        
        searchBar.searchTextField.becomeFirstResponder()
    }
    
    private func updateConstraints(forHidingSearchBar isHidden: Bool) {
        if isHidden {
            dateButtonsHorizontalViewTopAnchorConstraintsIfSearchBarIsShown.isActive = false
            dateButtonsHorizontalViewTopAnchorConstraintsIfSearchBarIsHidden.isActive = true
        } else {
            dateButtonsHorizontalViewTopAnchorConstraintsIfSearchBarIsHidden.isActive = false
            dateButtonsHorizontalViewTopAnchorConstraintsIfSearchBarIsShown.isActive = true
        }
        
        dateButtonsHorizontalView.layoutIfNeeded()
    }
    
    @objc private func didTapAddButton() {
        let selectedDate = viewModel.selectedDate ?? .now
        let createTaskVC = CreateTaskViewController(selectedDate: selectedDate)
        createTaskVC.valueChangedDidSave = {
            self.reloadData()
        }
        
        self.present(
            UINavigationController(rootViewController: createTaskVC),
            animated: true
        )
    }
    
    @objc private func didTapDateButton(_ sender: DateButton) {
        filterView.setDefaultFilterValues()
        
        if let index = viewModel.selectingDateButtonIndex {
            dateButtons[index].updateUI(for: .unselected)
        }
        
        viewModel.selectingDateButtonIndex = sender.tag
        sender.updateUI(for: .selecting)
    
        reloadData()
    }
    
    @objc private func didTapLongPressOnCollectionViewCell(
        _ gesture: UILongPressGestureRecognizer
    ) {
        guard gesture.state == .began else { return }
        
        // Get location and find indexPath of that
        let location = gesture.location(in: collectionView)
        guard let indexPath = collectionView.indexPathForItem(at: location)
        else { return }
        
        let actionSheet = UIAlertController(
            title: viewModel.sortedTaskItems[indexPath.row].title,
            message: "What do you want to perform with this task?",
            preferredStyle: .actionSheet
        )
        
        // Create actions
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let deleteAction = UIAlertAction(
            title: "Delete",
            style: .destructive,
            handler: { _ in
                self.deleteTaskItem(at: indexPath)
            }
        )
        let viewDetailAction = UIAlertAction(
            title: "View Detail",
            style: .default,
            handler: { _ in
                self.collectionView(
                    self.collectionView,
                    didSelectItemAt: indexPath
                )
            }
        )
        
        // Add actions
        actionSheet.addAction(viewDetailAction)
        actionSheet.addAction(deleteAction)
        actionSheet.addAction(cancelAction)
        
        // Display action sheet
        self.present(actionSheet, animated: true)
    }
    
    private func deleteTaskItem(at indexPath: IndexPath) {
        if viewModel.removeTaskItem(at: indexPath.row) {
            reloadData()
        } else {
            DispatchQueue.main.async { [weak self] in
                if let strongSelf = self {
                    strongSelf.present(strongSelf.connectionAlertVC, animated: true)
                }
            }
        }
    }
    
}


// MARK: - Conforms UISearchBarDelegate protocol
extension HomeViewController: UISearchBarDelegate {
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        // Hide search bar and show navigation bar
        navigationController?.isNavigationBarHidden = false
        updateConstraints(forHidingSearchBar: true)
        searchBar.isHidden = true
        searchBar.searchTextField.text = ""

        // Reload list of tasks and update bottom bar
        filterView.callApplyButtonAction()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let taskTitle = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if !taskTitle.isEmpty {
            viewModel.filterCurrentTaskItems(byTitle: taskTitle)
            collectionView.reloadData()
            updateBottomBar()
        } else {
            filterView.callApplyButtonAction()
        }
    }
    
}


// MARK: - Configure Date Buttons
extension HomeViewController {
    
    private static var numberOfDateButtons: Int {
        return DateManager.shared.daysOfWeek.count
    }
    private static let dateButtonSize = CGSize(width: 40, height: 80)
    private static let dateButtonCornerRadius: CGFloat = 20
    
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
        return viewModel.countTasks
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: TaskCollectionViewCell.identifier,
                for: indexPath
              ) as? TaskCollectionViewCell,
              viewModel.countTasks != 0
        else {
            return UICollectionViewCell()
        }
        
        cell.delegate = self
        cell.setDataModel(viewModel.sortedTaskItems[indexPath.row])
        
        return cell
    }
    
}


// MARK: - Conform UICollectionViewDelegate and collectionViewCellDelegate protocol
extension HomeViewController: UICollectionViewDelegate, TaskCollectionViewCellDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)

        if let taskItem = viewModel.getTaskItemInOriginalTasks(
            viewModel.sortedTaskItems[indexPath.row]
        ) {
            let taskDetailVC = TaskDetailViewController(taskItem: taskItem)
            
            // Because taskItems is auto updating,
            // so we don't have to call loadTaskItems() methods.
            taskDetailVC.valueChangedDidSave = {
                self.reloadData()
            }
            taskDetailVC.onDeletion = {
                self.deleteTaskItem(at: indexPath)
            }
            
            taskDetailVC.isHiddenNavigationBarAfterDimiss = !searchBar.isHidden
            navigationController?.isNavigationBarHidden = false
            
            navigationController?.pushViewController(taskDetailVC, animated: true)
        }
    }
    
    func taskCollectionViewCellDidToggleStar(_ cell: TaskCollectionViewCell) {
        guard let indexPath = collectionView.indexPath(for: cell) else {
            return
        }
        
        if viewModel.toggleStatusOfTaskItem(forStatus: .important, at: indexPath.row) {
            reloadData()
        } else {
            self.present(connectionAlertVC, animated: true)
        }
    }
    
    func taskCollectionViewCellDidToggleCheckmark(_ cell: TaskCollectionViewCell) {
        guard let indexPath = collectionView.indexPath(for: cell) else {
            return
        }
        
        if viewModel.toggleStatusOfTaskItem(forStatus: .completetion, at: indexPath.row) {
            reloadData()
        } else {
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
        let (predicateFormat, values) = viewModel.createPrecidateFormat(forStates: states)
        if predicateFormat.isEmpty {
            viewModel.loadTaskItems()
        } else {
            let predicate = NSPredicate(format: predicateFormat, argumentArray: values)
            viewModel.loadTaskItems(withPredicateFormat: predicate.predicateFormat)
        }
        
        collectionView.reloadData()
        updateBottomBar()
        bottomBarView.isHidden = false
    }
    
}
