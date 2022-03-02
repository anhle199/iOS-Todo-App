//
//  TextEditorPopupView.swift
//  Todo
//
//  Created by Le Hoang Anh on 01/03/2022.
//

import UIKit

protocol TextEditorPopupViewDelegate: AnyObject {
    func textEditorPopupViewWillAppear(_ textEditorPopup: TextEditorPopupView)
    func textEditorPopupViewDidDisappear(_ textEditorPopup: TextEditorPopupView)
    func textEditorPopupViewDidFinishEditing(_ textEditorPopup: TextEditorPopupView)
}

class TextEditorPopupView: UIView {

    // MARK: - Enumerations
    enum BarButtonType: Int {
        case close
        case cancel
        case edit
        case done
    }

    enum EditMode {
        case active
        case inactive
    }
    
    
    // MARK: - Delegation Pattern
    weak var delegate: TextEditorPopupViewDelegate?
    
    
    // MARK: - Initialize Subviews
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemGray5
        view.makeRoundCorners(for: .all, radius: 16)
        
        return view
    }()
    
    private let navigationBarView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemGray3
        view.makeRoundCorners(for: [.topLeft, .topRight], radius: 16)
        
        return view
    }()
    
    private let leftBarButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Close", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.setTitleColor(.systemGray, for: .disabled)
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .medium)
        button.tag = BarButtonType.close.rawValue
        
        return button
    }()
    
    private let navigationBarTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Text Editor"
        label.font = .boldSystemFont(ofSize: 17)
        
        return label
    }()
    
    private let rightBarButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Edit", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.setTitleColor(.systemGray, for: .disabled)
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .medium)
        button.tag = BarButtonType.edit.rawValue
        
        return button
    }()
    
    private let textView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.backgroundColor = .systemBackground
        textView.font = .systemFont(ofSize: 17)
        textView.makeRoundCorners(for: .all, radius: 8)
        textView.makeBorder(withColor: .lightGray, width: 0.5)
        textView.autocorrectionType = .no
        textView.textAlignment = .left
        
        return textView
    }()
    
    
    // MARK: - Observed Properties
    override var isHidden: Bool {
        willSet {
            if !newValue {
                delegate?.textEditorPopupViewWillAppear(self)
            }
        }
        didSet {
            if isHidden {
                delegate?.textEditorPopupViewDidDisappear(self)
            }
        }
    }
    
    private var editMode: EditMode = .inactive {
        didSet {
            switch editMode {
            case .active:
                leftBarButton.setTitle("Cancel", for: .normal)
                leftBarButton.tag = BarButtonType.cancel.rawValue
                
                rightBarButton.setTitle("Done", for: .normal)
                rightBarButton.tag = BarButtonType.done.rawValue
                rightBarButton.isEnabled = false
                
                // Starts textView's edit mode
                textView.becomeFirstResponder()
                
            case .inactive:
                leftBarButton.setTitle("Close", for: .normal)
                leftBarButton.tag = BarButtonType.close.rawValue
                
                rightBarButton.setTitle("Edit", for: .normal)
                rightBarButton.tag = BarButtonType.edit.rawValue
                rightBarButton.isEnabled = true
            }
        }
    }
    
    
    // MARK: - Stored Properties
    var isEditable: Bool {
        get { textView.isEditable }
        set {
            textView.isEditable = newValue
            
            if newValue {
                isPreventedChangeEditMode = false
            } else {
                isPreventedChangeEditMode = true
                editMode = .inactive
                rightBarButton.isHidden = true
            }
        }
    }
    
    var navigationTitle: String {
        get { navigationBarTitleLabel.text ?? "" }
        set { self.navigationBarTitleLabel.text = newValue }
    }
    
    private var isPreventedChangeEditMode = false
    
    private var originalText: String
    
    /// Value of this variable is current text in the editor.
    /// If user click to the `Cancel` button, value of this variable will be changed
    /// to the original value before starting editing mode.
    private(set) var text: String  // read-only in public
   
    
    // MARK: - Initializers
    convenience init() {
        self.init(text: "")
    }
    
    init(text: String) {
        self.originalText = text
        self.text = text
        
        super.init(frame: .zero)
        
        backgroundColor = .black.withAlphaComponent(0.7)
        
        setUpSubviews()
        setUpConstraints()
        
        // Add action for navigation bar buttons
        leftBarButton.addTarget(
            self,
            action: #selector(didTapLeftBarButton),
            for: .touchUpInside
        )
        rightBarButton.addTarget(
            self,
            action: #selector(didTapRightBarButton),
            for: .touchUpInside
        )
        
        // Add a tap gesture for dimming view
        self.addGestureRecognizer(
            UITapGestureRecognizer(
                target: self,
                action: #selector(didTapDimmingArea)
            )
        )
        
        textView.text = text
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Button Actions
    @objc private func didTapDimmingArea(_ gesture: UITapGestureRecognizer) {
        if gesture.state == .ended && gesture.didTapOutside(of: contentView) {
            isHidden = true
        }
    }
    
    @objc private func didTapLeftBarButton(_ sender: UIButton) {
        let barButtonType = BarButtonType(rawValue: sender.tag)

        if barButtonType == .close {
            isHidden = true
        } else if barButtonType == .cancel {
            // Disabled state of user typing to restore current text to the original text
            self.textView.isEditable = false
            
            self.text = originalText
            self.textView.text = originalText
            textView.endEditing(true)
            
            // Enabled state of user typing
            self.textView.isEditable = true
        }
    }
    
    @objc private func didTapRightBarButton(_ sender: UIButton) {
        let barButtonType = BarButtonType(rawValue: sender.tag)
        
        if barButtonType == .edit {
            self.editMode = .active
        } else if barButtonType == .done {
            // Disabled state of user typing to store current text to the original text
            self.textView.isEditable = false
            
            self.originalText = text
            textView.endEditing(true)
            
            // Enabled state of user typing
            self.textView.isEditable = true
        }
    }
    
    
    // MARK: - Configuration Methods
    private func setUpSubviews() {
        addSubview(contentView)
        
        contentView.addSubview(navigationBarView)
        contentView.addSubview(textView)
        
        navigationBarView.addSubview(leftBarButton)
        navigationBarView.addSubview(navigationBarTitleLabel)
        navigationBarView.addSubview(rightBarButton)
        
        textView.delegate = self
    }
    
    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            contentView.centerXAnchor.constraint(equalTo: centerXAnchor),
            contentView.centerYAnchor.constraint(equalTo: centerYAnchor),
            contentView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.75),
            contentView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.5),
            
            navigationBarView.topAnchor.constraint(equalTo: contentView.topAnchor),
            navigationBarView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            navigationBarView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            navigationBarView.heightAnchor.constraint(equalToConstant: 40),
            
            textView.topAnchor.constraint(equalTo: navigationBarView.bottomAnchor, constant: 8),
            textView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            textView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            textView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            
            navigationBarTitleLabel.centerXAnchor.constraint(equalTo: navigationBarView.centerXAnchor),
            navigationBarTitleLabel.centerYAnchor.constraint(equalTo: navigationBarView.centerYAnchor),
            
            leftBarButton.centerYAnchor.constraint(equalTo: navigationBarView.centerYAnchor),
            leftBarButton.leadingAnchor.constraint(equalTo: navigationBarView.leadingAnchor, constant: 16),
            
            rightBarButton.centerYAnchor.constraint(equalTo: navigationBarView.centerYAnchor),
            rightBarButton.trailingAnchor.constraint(equalTo: navigationBarView.trailingAnchor, constant: -16),
        ])
    }
    
    
    // MARK: - Other Methods
    func setText(_ text: String) {
        self.originalText = text
        self.text = text
        textView.text = text
    }
    
    func setEditMode(_ editMode: EditMode) {
        if !isPreventedChangeEditMode {
            self.editMode = editMode
        }
    }
    
}


// MARK: - Conforms the UITextViewDelegate protocol
extension TextEditorPopupView: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        self.editMode = .active
    }
    
    func textViewDidChange(_ textView: UITextView) {
        self.text = textView.text
        rightBarButton.isEnabled = (text != originalText)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        self.editMode = .inactive
        delegate?.textEditorPopupViewDidFinishEditing(self)
    }
    
}
