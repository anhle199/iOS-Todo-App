//
//  LoadingView.swift
//  Todo
//
//  Created by Le Hoang Anh on 06/03/2022.
//

import UIKit

class LoadingView: UIView {
    
    private let spinnerView: UIActivityIndicatorView = {
        let indicatorView = UIActivityIndicatorView(style: .medium)
        indicatorView.translatesAutoresizingMaskIntoConstraints = false
        indicatorView.backgroundColor = .white
        indicatorView.hidesWhenStopped = true
        
        return indicatorView
    }()
    
    private let label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Loading data...\nPlease wait a few seconds."
        label.textAlignment = .center
        label.numberOfLines = 0
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .systemBackground
        
        addSubview(spinnerView)
        addSubview(label)
        
        NSLayoutConstraint.activate([
            spinnerView.centerXAnchor.constraint(equalTo: centerXAnchor),
            spinnerView.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            label.topAnchor.constraint(equalTo: spinnerView.bottomAnchor, constant: 8),
            label.centerXAnchor.constraint(equalTo: centerXAnchor),
        ])
    }
    
    func startAnimating() {
        spinnerView.startAnimating()
        isHidden = false
    }
    
    func endAnimating() {
        isHidden = true
        spinnerView.stopAnimating()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
