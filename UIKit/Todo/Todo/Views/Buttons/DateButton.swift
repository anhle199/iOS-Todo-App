//
//  DateButton.swift
//  Todo
//
//  Created by Le Hoang Anh on 23/02/2022.
//

import UIKit

final class DateButton: UIButton {
    
    // MARK: - Initialize Subviews
    private let verticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.isUserInteractionEnabled = false
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 0
        stackView.backgroundColor = .clear
        
        return stackView
    }()
    
    private let dayNumberLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemBackground
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 15)
        label.backgroundColor = .clear
        
        return label
    }()
    
    private let weekdayLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemBackground
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 15)
        label.backgroundColor = .clear
        
        return label
    }()
    
    // background frame of circle
    private let backgroundFrameCircleView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        
        return view
    }()
    
    // circle view
    private let circleView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemBackground
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 4
        
        return view
    }()
    
    
    // MARK: - Observed Properties
    var dayNumberValue: Int = 1 {
        didSet { dayNumberLabel.text = String(format: "%02d", dayNumberValue) }
    }
    
    var weekdaySymbolValue: String = "Sun" {
        didSet { weekdayLabel.text = weekdaySymbolValue }
    }
    
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .label
        setUpSubviews()
        
        // create and assign default data
        let todayDateComponents = Calendar.current.dateComponents(
            in: .current,
            from: .now
        )
        if let dayNumber = todayDateComponents.day,
           let weekday = todayDateComponents.weekday {
            
            dayNumberValue = dayNumber
            weekdaySymbolValue = Calendar.current.shortWeekdaySymbols[weekday - 1]  // - 1]
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Configuration Methods
    private func setUpSubviews() {
        addAllSubviews()
        setUpConstraints()
    }
    
    private func addAllSubviews() {
        addSubview(verticalStackView)
        
        verticalStackView.addArrangedSubview(dayNumberLabel)
        verticalStackView.addArrangedSubview(weekdayLabel)
        verticalStackView.addArrangedSubview(backgroundFrameCircleView)
        
        backgroundFrameCircleView.addSubview(circleView)
    }
    
    private func setUpConstraints() {
        // Constaints
        NSLayoutConstraint.activate([
            verticalStackView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            verticalStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            verticalStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            verticalStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            
            circleView.widthAnchor.constraint(equalToConstant: 8),
            circleView.heightAnchor.constraint(equalTo: circleView.widthAnchor),
            circleView.centerXAnchor.constraint(equalTo: backgroundFrameCircleView.centerXAnchor),
            circleView.centerYAnchor.constraint(equalTo: backgroundFrameCircleView.centerYAnchor),
        ])
    }
    
    func makeRoundedCorners(withRadius radius: CGFloat) {
        layer.masksToBounds = true
        layer.cornerRadius = radius
    }
    
    // This enumeration is used for update background and
    // foreground color of this button.
    enum State {
        case selecting
        case unselected
    }
    
    func setColors(for state: State, withAnimation animated: Bool) {
        let backgroundColor: UIColor
        let foregroundColor: UIColor
        let colorForCircleView: UIColor
        
        switch state {
        case .selecting:
            backgroundColor = .label
            foregroundColor = .systemBackground
            colorForCircleView = foregroundColor
        case .unselected:
            backgroundColor = .clear
            foregroundColor = .secondaryLabel
            colorForCircleView = backgroundColor
        }
        
        if animated {
            UIView.animate(withDuration: 0.2) {
                self.backgroundColor = backgroundColor
                self.dayNumberLabel.textColor = foregroundColor
                self.weekdayLabel.textColor = foregroundColor
                self.circleView.backgroundColor = colorForCircleView
            }
        } else {
            self.backgroundColor = backgroundColor
            self.dayNumberLabel.textColor = foregroundColor
            self.weekdayLabel.textColor = foregroundColor
            self.circleView.backgroundColor = colorForCircleView
        }
    }
    
    func updateUI(for state: State) {
        setColors(for: state, withAnimation: true)
        // Do more in the future...
    }
    
}
