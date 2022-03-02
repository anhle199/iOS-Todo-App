//
//  DetailViewController.swift
//  Todo
//
//  Created by Le Hoang Anh on 28/02/2022.
//

import UIKit

class DetailViewController: UIViewController {

    // MARK: - View Model
    let viewModel: DetailViewControllerViewModel
    
    
    // MARK: - Declaration of Navigation Bar Buttons
    var cancelButton: UIBarButtonItem!
    var editButton: UIBarButtonItem!
    var doneButton: UIBarButtonItem!
    
    
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
    @objc private func didTapEdit() {
        print("DetailViewController - didtapEdit()")
        navigationItem.leftBarButtonItem = cancelButton
        navigationItem.rightBarButtonItem = doneButton
    }
    
    @objc private func didTapCancel() {
        print("DetailViewController - didTapCancel()")
        navigationItem.leftBarButtonItem = nil  //navigationController?.navigationBar.topItem?.backBarButtonItem
        navigationItem.rightBarButtonItem = editButton
    }
    
    @objc private func didTapDone() {
        print("DetailViewController - didTapDone()")
        navigationItem.leftBarButtonItem = nil  //navigationController?.navigationBar.topItem?.backBarButtonItem
        navigationItem.rightBarButtonItem = editButton
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
        editButton = UIBarButtonItem(
            barButtonSystemItem: .edit,
            target: self,
            action: #selector(didTapEdit)
        )
        doneButton = UIBarButtonItem(
            barButtonSystemItem: .done,
            target: self,
            action: #selector(didTapDone)
        )
        
        title = "Detail"
        navigationItem.rightBarButtonItem = editButton
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
            
            toggleButtonCell.title = (type == .completed) ? "Completed" : "Important"
            toggleButtonCell.setOn(
                (type == .completed) ? viewModel.taskItem.isDone : viewModel.taskItem.isImportant,
                animated: true
            )
            cell = toggleButtonCell
            
        case .text(.textField):
            let textFieldCell = tableView.dequeueReusableCell(
                withIdentifier: TextFieldTableViewCell.identifier,
                for: indexPath
            ) as! TextFieldTableViewCell
            
            textFieldCell.title = "Task name"
            textFieldCell.textValue = viewModel.taskItem.title
            textFieldCell.delegate = self
            cell = textFieldCell
            
        case .pickerView(let type):
            let timePickerCell = tableView.dequeueReusableCell(
                withIdentifier: PickerTableViewCell.identifier,
                for: indexPath
            ) as! PickerTableViewCell
            
            timePickerCell.title = (type == .time) ? "Due time" : "Take place on"
            timePickerCell.pickerMode = (type == .time) ? .time : .date
            timePickerCell.pickerStyle = .compact
            timePickerCell.setDate(viewModel.taskItem.dueTime, animated: true)
            cell = timePickerCell
            
        case .text(.textView):
            let textViewCell = tableView.dequeueReusableCell(
                withIdentifier: TextViewTableViewCell.identifier,
                for: indexPath
            ) as! TextViewTableViewCell
            
            textViewCell.textValue = viewModel.taskItem.taskDescription
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
    
    func TextTableViewCellDidTap(_ textTableView: TextTableViewCell, cellStype type: DetailCellStyle.TextType) {
        textEditorPopup.navigationTitle = type == .textField ? "Task Name" : "Description"
        textEditorPopup.setText(textTableView.textValue)
        textEditorPopup.isEditable = true
        textEditorPopup.isHidden = false
    }
    
}


// MARK: - Conform the TextEditorPopupViewDelegate protocol
extension DetailViewController: TextEditorPopupViewDelegate {
    
    func textEditorPopupViewDidFinishEditing(_ textEditorPopup: TextEditorPopupView) {
        print("textEditorPopupViewDidFinishEditing - \(textEditorPopup.text)")
    }
    
    func textEditorPopupViewWillAppear(_ textEditorPopup: TextEditorPopupView) {
        self.navigationController?.navigationBar.isUserInteractionEnabled = false
    }
    
    func textEditorPopupViewDidDisappear(_ textEditorPopup: TextEditorPopupView) {
        self.navigationController?.navigationBar.isUserInteractionEnabled = true
    }
    
}
