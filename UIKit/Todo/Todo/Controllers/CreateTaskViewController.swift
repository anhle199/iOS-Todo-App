//
//  CreateTaskViewController.swift
//  Todo
//
//  Created by Le Hoang Anh on 03/03/2022.
//

import UIKit

class CreateTaskViewController: DetailBaseViewController {

    // MARK: - Declaration of Navigation Bar Buttons
    var closeButton: UIBarButtonItem!
    var doneButton: UIBarButtonItem!
    
    
    // MARK: - Initializers
    override init() {
        super.init()
        
        self.viewModel = CreateTaskViewModel(dueTime: .now)
        
        self.numberOfRowsInEachSection = [2, 2, 1]
        self.numberOfSections = numberOfRowsInEachSection.count
        self.dueTimeSection = 1
        
        self.titleForHeaderInSections = [
            "BASIC",
            "DUE DATE",
            "DESCRIPTION",
        ]
        self.titleForFooterInSections = [
            "Click on text value of task name to open text editor for that.",
            "This task will only take place selected week.",
            "Click on any position of description text or white space to open text editor for that.",
        ]
        
        self.cellStyles = [
            [ .text(.textField), .toggle(.important) ],
            [ .pickerView(.time), .pickerView(.date) ],
            [ .text(.textView) ]
        ]
        
        self.heightForRowInSections = [44, 44, 200]
    }
    
    convenience init(selectedDate: Date) {
        self.init()
        self.viewModel = CreateTaskViewModel(dueTime: selectedDate)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpNavigationBar()
    }

    
    // MARK: - Configuration Subview Methods
    private func setUpNavigationBar() {
        closeButton = UIBarButtonItem(
            title: "Close",
            style: .plain,
            target: self,
            action: #selector(didTapCancel)
        )
        doneButton = UIBarButtonItem(
            title: "Done",
            style: .done,
            target: self,
            action: #selector(didTapSave)
        )
        doneButton.isEnabled = false
        
        title = "Create"
        navigationItem.leftBarButtonItem = closeButton
        navigationItem.rightBarButtonItem = doneButton
    }

    
    // MARK: - Navigation Bar Button Actions
    @objc private func didTapCancel() {
        viewModel.rollback(completion: nil)
        // need to show alert for yes/no selection to dismiss this view controller
        self.dismiss(animated: true)
    }
    
    @objc private func didTapSave() {
        viewModel.commit { success in
            if !success {
                DispatchQueue.main.async {
                    self.present(self.connectionAlertVC, animated: true)
                }
            }
        }
        tableView.reloadData()
        self.valueChangedDidSave?()
        
        // need to show alert for yes/no selection to dismiss this view controller
        self.dismiss(animated: true)
    }
    
    
    // MARK: - Override Method That Conformed From The TextTableViewCellDelegate Protocol
    override func detailTableViewCellDidChangeValue(
        _ detailTableView: DetailTableViewCell,
        cellStype type: DetailCellStyle
    ) {
        super.detailTableViewCellDidChangeValue(detailTableView, cellStype: type)
        doneButton.isEnabled = !viewModel.draftTaskItem.title.isEmpty
    }
    
}
