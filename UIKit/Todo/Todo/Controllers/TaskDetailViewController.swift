//
//  TaskDetailViewController.swift
//  Todo
//
//  Created by Le Hoang Anh on 03/03/2022.
//

import UIKit

class TaskDetailViewController: DetailBaseViewController {
    
    // MARK: - Declaration of Navigation Bar Buttons
    var cancelButton: UIBarButtonItem!
    var saveButton: UIBarButtonItem!
    var deleteButton: UIBarButtonItem!
    
    
    // MARK: - Callback Functions
    var onDeletion: (() -> Void)?
    
    
    // MARK: - Initializers
    override private init() {
        super.init()
    }
    
    init(taskItem: TaskItem) {
        super.init()
        
        self.viewModel = TaskDetailViewModel(from: taskItem)
        
        self.numberOfRowsInEachSection = [1, 2, 2, 1]
        self.numberOfSections = numberOfRowsInEachSection.count
        self.dueTimeSection = 2
        
        self.titleForHeaderInSections = [
            "STATUS",
            "BASIC",
            "DUE DATE",
            "DESCRIPTION",
        ]
        self.titleForFooterInSections = [
            "",
            "Click on text value of task name to open text editor for that.",
            "This task will only take place this week.",
            "Click on any position of description text or white space to open text editor for that.",
        ]
        
        self.cellStyles = [
            [ .toggle(.completed) ],
            [ .text(.textField), .toggle(.important) ],
            [ .pickerView(.time), .pickerView(.date) ],
            [ .text(.textView) ]
        ]
        
        self.heightForRowInSections = [44, 44, 44, 200]
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
        let backButton = UIBarButtonItem()
        backButton.title = "Back"
        navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        
        cancelButton = UIBarButtonItem(
            title: "Cancel",
            style: .plain,
            target: self,
            action: #selector(didTapCancel)
        )
        saveButton = UIBarButtonItem(
            title: "Save",
            style: .done,
            target: self,
            action: #selector(didTapSave)
        )
        deleteButton = UIBarButtonItem(
            barButtonSystemItem: .trash,
            target: self,
            action: #selector(didTapDelete)
        )
        deleteButton.tintColor = .systemRed
        
        title = "Detail"
        navigationItem.rightBarButtonItem = deleteButton
    }
    
    
    // MARK: - Navigation Bar Button Actions
    @objc private func didTapCancel() {
        navigationItem.leftBarButtonItem = nil  //navigationController?.navigationBar.topItem?.backBarButtonItem
        navigationItem.rightBarButtonItem = deleteButton
        title = "Detail"
        
        viewModel.rollback(completion: nil)
        tableView.reloadData()
    }
    
    @objc private func didTapSave() {
        navigationItem.leftBarButtonItem = nil  //navigationController?.navigationBar.topItem?.backBarButtonItem
        navigationItem.rightBarButtonItem = deleteButton
        title = "Detail"
        
        viewModel.commit { success in
            if !success {
                DispatchQueue.main.async {
                    self.present(self.connectionAlertVC, animated: true)
                }
            }
        }
        tableView.reloadData()
        self.valueChangedDidSave?()
    }
    
    @objc private func didTapDelete() {
        if let onDeletion = onDeletion {
            onDeletion()
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    
    // MARK: - Override Method That Conformed From The TextTableViewCellDelegate Protocol
    override func detailTableViewCellDidChangeValue(
        _ detailTableView: DetailTableViewCell,
        cellStype type: DetailCellStyle
    ) {
        super.detailTableViewCellDidChangeValue(detailTableView, cellStype: type)
        
        if viewModel.hasChanges {
            self.navigationItem.leftBarButtonItem = cancelButton
            self.navigationItem.rightBarButtonItem = saveButton
            self.title = "Detail (Edtiting)"
        } else {
            self.navigationItem.leftBarButtonItem = nil
            self.navigationItem.rightBarButtonItem = deleteButton
            self.title = "Detail"
        }
    }
    
    
    // MARK: - Override Methods That Conformed From The TextEditorPopupViewDelegate Protocol
    override func textEditorPopupViewWillAppear(_ textEditorPopup: TextEditorPopupView) {
        self.deleteButton.isEnabled = false
        super.textEditorPopupViewWillAppear(textEditorPopup)
    }
    
    override func textEditorPopupViewDidDisappear(_ textEditorPopup: TextEditorPopupView) {
        self.deleteButton.isEnabled = true
        super.textEditorPopupViewDidDisappear(textEditorPopup)
    }
    
}
