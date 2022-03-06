//
//  PickerTableViewCell.swift
//  Todo
//
//  Created by Le Hoang Anh on 28/02/2022.
//

import UIKit

class PickerTableViewCell: UITableViewCell, DetailTableViewCell {

    // MARK: - Reuse Identifier
    static let identifier = "PickerTableViewCell"
    
    
    // MARK: - Delegation Pattern
    weak var delegate: DetailTableViewCellDelegate?
    
    
    // MARK: - Initialize Subviews
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        label.font = Constants.SystemTableView.CellView.font
        
        return label
    }()
    
    private let pickerView: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .compact
        datePicker.setDate(.now, animated: false)
        
        let dateManager = DateManager.shared
        if let minDate = dateManager.daysOfWeek.first, let maxDate = dateManager.daysOfWeek.last {
            datePicker.minimumDate = dateManager.startTime(of: minDate)
            datePicker.maximumDate = dateManager.endTime(of: maxDate)
        }
        
        return datePicker
    }()
    
    
    // MARK: - Stored Properties
    var title: String {
        get { titleLabel.text ?? "" }
        set { self.titleLabel.text = newValue }
    }
    
    var pickerMode: UIDatePicker.Mode {
        get { pickerView.datePickerMode }
        set { self.pickerView.datePickerMode = newValue }
    }
    
    var pickerStyle: UIDatePickerStyle {
        get { pickerView.preferredDatePickerStyle }
        set { self.pickerView.preferredDatePickerStyle = newValue }
    }
    
    var cellStyle: DetailCellStyle?
    
    
    // MARK: - Computed Properties
    var date: Date { pickerView.date }
    
    
    // MARK: - Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(pickerView)

        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: pickerView.leadingAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),

            pickerView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            pickerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
        ])
        
        pickerView.addTarget(self, action: #selector(didChangeDate), for: .valueChanged)
    }
    
    @objc private func didChangeDate() {
        guard let type = cellStyle else { return }
        delegate?.detailTableViewCellDidChangeValue(self, cellStype: type)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Other Methods
    func setDate(_ date: Date, animated: Bool) {
        pickerView.setDate(date, animated: animated)
    }

}
