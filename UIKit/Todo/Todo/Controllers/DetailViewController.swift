//
//  DetailViewController.swift
//  Todo
//
//  Created by Le Hoang Anh on 28/02/2022.
//

import UIKit
import RealmSwift

class DetailViewController: UIViewController {

    // MARK: - View Model
    var viewModel: DetailViewControllerViewModel
    
    
    // MARK: - Declaration of Navigation Bar Buttons
    var cancelButton: UIBarButtonItem!
    var saveButton: UIBarButtonItem!
    var deleteButton: UIBarButtonItem!
    
    
    // MARK: - Initialize Subviews
    private var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.allowsSelection = false
        
        return tableView
    }()
    
    private var textEditorPopup: TextEditorPopupView = {
        let popupView = TextEditorPopupView(text: "")
        popupView.translatesAutoresizingMaskIntoConstraints = false
        popupView.isHidden = true
        
        return popupView
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
    
    
    // MARK: - Callback Functions
    var valueChangedDidSave: (() -> Void)?
    var onDeletion: (() -> Void)?
    
    
    // MARK: - Initializer
    init(taskItem: TaskItem) {
        self.viewModel = .init(from: taskItem)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        setUpNavigationBar()
        setUpTableView()
        setUpTextEditorPopup()
    }
    
    
    // MARK: - Navigation Bar Button Actions
    @objc private func didTapCancel() {
        navigationItem.leftBarButtonItem = nil  //navigationController?.navigationBar.topItem?.backBarButtonItem
        navigationItem.rightBarButtonItem = deleteButton
        title = "Detail"
        
        viewModel.rollback()
        tableView.reloadData()
    }
    
    @objc private func didTapSave() {
        navigationItem.leftBarButtonItem = nil  //navigationController?.navigationBar.topItem?.backBarButtonItem
        navigationItem.rightBarButtonItem = deleteButton
        title = "Detail"
        
        viewModel.commitChanges { success in
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
    
    private func setUpTableView() {
        tableView.register(
            ToggleButtonTableViewCell.self,
            forCellReuseIdentifier: ToggleButtonTableViewCell.identifier
        )
        tableView.register(
            TextFieldTableViewCell.self,
            forCellReuseIdentifier: TextFieldTableViewCell.identifier
        )
        tableView.register(
            PickerTableViewCell.self,
            forCellReuseIdentifier: PickerTableViewCell.identifier
        )
        tableView.register(
            TextViewTableViewCell.self,
            forCellReuseIdentifier: TextViewTableViewCell.identifier
        )
        
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
        ])
    }
    
    private func setUpTextEditorPopup() {
        textEditorPopup.delegate = self
        view.addSubview(textEditorPopup)

        NSLayoutConstraint.activate([
            textEditorPopup.topAnchor.constraint(equalTo: view.topAnchor),
            textEditorPopup.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            textEditorPopup.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            textEditorPopup.leadingAnchor.constraint(equalTo: view.leadingAnchor),
        ])
    }
    
    
    // MARK: - Testing
    private var whichTextCellEditingFromPopup: TextTableViewCell?
    
}


// MARK: - Conform both UITableViewDelegate and UITableViewDataSource protocols
extension DetailViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return Constants.DetailTableView.numberOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Constants.DetailTableView.numberOfRowsInEachSection[section]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell
        let cellStyle = Constants.DetailTableView.cellStyles[indexPath.section][indexPath.row]
        
        switch cellStyle {
        case .toggle(let type):
            let toggleButtonCell = tableView.dequeueReusableCell(
                withIdentifier: ToggleButtonTableViewCell.identifier,
                for: indexPath
            ) as! ToggleButtonTableViewCell
            
            toggleButtonCell.cellStyle = .toggle(type)
            toggleButtonCell.title = (type == .completed) ? "Completed" : "Important"
            toggleButtonCell.setOn(
                (type == .completed) ? viewModel.draftTaskItem.isDone : viewModel.draftTaskItem.isImportant,
                animated: true
            )
            toggleButtonCell.delegate = self
            cell = toggleButtonCell
            
        case .text(.textField):
            let textFieldCell = tableView.dequeueReusableCell(
                withIdentifier: TextFieldTableViewCell.identifier,
                for: indexPath
            ) as! TextFieldTableViewCell
            
            textFieldCell.cellStyle = .text(.textField)
            textFieldCell.title = "Task name"
            textFieldCell.textValue = viewModel.draftTaskItem.title
            textFieldCell.delegate = self
            cell = textFieldCell
            
        case .pickerView(let type):
            let timePickerCell = tableView.dequeueReusableCell(
                withIdentifier: PickerTableViewCell.identifier,
                for: indexPath
            ) as! PickerTableViewCell
            
            timePickerCell.cellStyle = .pickerView(type)
            timePickerCell.title = (type == .time) ? "Due time" : "Take place on"
            timePickerCell.pickerMode = (type == .time) ? .time : .date
            timePickerCell.pickerStyle = .compact
            timePickerCell.setDate(viewModel.draftTaskItem.dueTime, animated: true)
            timePickerCell.delegate = self
            cell = timePickerCell
            
        case .text(.textView):
            let textViewCell = tableView.dequeueReusableCell(
                withIdentifier: TextViewTableViewCell.identifier,
                for: indexPath
            ) as! TextViewTableViewCell
            
            textViewCell.cellStyle = .text(.textView)
            textViewCell.textValue = viewModel.draftTaskItem.taskDescription
            textViewCell.delegate = self
            cell = textViewCell
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.DetailTableView.heightForRowInSections[indexPath.section]
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return Constants.DetailTableView.titleForHeaderInSections[section]
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return Constants.DetailTableView.titleForFooterInSections[section]
    }
    
}


// MARK: - Conform the TextTableViewCellDelegate protocol
extension DetailViewController: TextTableViewCellDelegate {
    
    func detailTableViewCellDidChangeValue(
        _ detailTableView: DetailTableViewCell,
        cellStype type: DetailCellStyle
    ) {
        self.navigationItem.leftBarButtonItem = cancelButton
        self.navigationItem.rightBarButtonItem = saveButton
        self.title = "Detail (Edtiting)"
        
        switch type {
        case .toggle(let toggleCellType):
            let cell = detailTableView as! ToggleButtonTableViewCell
            
            // Update data of view model
            if toggleCellType == .completed {
                viewModel.draftTaskItem.isDone = cell.isOn
            } else if toggleCellType == .important {
                viewModel.draftTaskItem.isImportant = cell.isOn
            }
            
        case .text(let textCellType):
            let textCell = detailTableView as! TextTableViewCell
            
            switch textCellType {
            case .textField:
                let cell = textCell as! TextFieldTableViewCell
                if let indexPath = tableView.indexPath(for: cell) {
                    viewModel.draftTaskItem.title = cell.textValue
                    tableView.reloadRows(at: [indexPath], with: .none)
                }
                
            case .textView:
                let cell = textCell as! TextViewTableViewCell
                if let indexPath = tableView.indexPath(for: cell) {
                    viewModel.draftTaskItem.taskDescription = cell.textValue
                    tableView.reloadRows(at: [indexPath], with: .none)
                }
            }
    
        case .pickerView(let pickViewType):
            let cell = detailTableView as! PickerTableViewCell
            
            // Update date of view model
            viewModel.draftTaskItem.dueTime = cell.date

            // TODO: - Currently, hard coded
            let row = (pickViewType == .date) ? 0 : 1
            tableView.reloadRows(at: [.init(row: row, section: 2)], with: .none)
        }
    }
    
    func textTableViewCellShouldDisplayTextEditorPopup(
        _ textTableView: TextTableViewCell,
        cellStype type: DetailCellStyle.TextType
    ) {
        textEditorPopup.navigationTitle = type == .textField ? "Task Name" : "Description"
        textEditorPopup.setText(textTableView.textValue)
        textEditorPopup.isEditable = true
        textEditorPopup.isHidden = false
     
        self.whichTextCellEditingFromPopup = textTableView
    }
    
}


// MARK: - Conform the TextEditorPopupViewDelegate protocol
extension DetailViewController: TextEditorPopupViewDelegate {
    
    func textEditorPopupViewDidFinishEditing(
        _ textEditorPopup: TextEditorPopupView,
        valueChanged isChanged: Bool
    ) {
        print("textEditorPopupViewDidFinishEditing - \(isChanged) - \(textEditorPopup.text)")
    }
    
    func textEditorPopupViewWillAppear(_ textEditorPopup: TextEditorPopupView) {
        self.navigationController?.navigationBar.isUserInteractionEnabled = false
    }
    
    func textEditorPopupViewDidDisappear(_ textEditorPopup: TextEditorPopupView) {
        self.navigationController?.navigationBar.isUserInteractionEnabled = true

        guard let cell = whichTextCellEditingFromPopup,
              viewModel.draftTaskItem.title != textEditorPopup.text
        else { return }
        
        cell.setText(textEditorPopup.text, andWantToCallDelegate: true)
        self.whichTextCellEditingFromPopup = nil
    }
    
}
