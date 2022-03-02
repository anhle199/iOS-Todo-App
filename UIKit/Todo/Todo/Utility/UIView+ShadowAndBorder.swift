//
//  UIView+ShadowAndBorder.swift
//  Todo
//
//  Created by Le Hoang Anh on 01/03/2022.
//

import UIKit

extension UIView {
    
    func dropShadow(
        withColor color: UIColor = .label,
        offset: CGSize = .zero,
        opacity: Float = 0.5,
        radius: CGFloat = 2
    ) {
        layer.shadowColor = color.cgColor
        layer.shadowOffset = offset
        layer.shadowOpacity = opacity
        layer.shadowRadius = radius
    }

    func makeBorder(withColor color: UIColor = .black, width: CGFloat = 1.0) {
        layer.borderColor = color.cgColor
        layer.borderWidth = width
    }
    
}
