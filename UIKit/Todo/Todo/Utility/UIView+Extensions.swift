//
//  UIView+Extensions.swift
//  Todo
//
//  Created by Le Hoang Anh on 26/02/2022.
//

import UIKit

extension UIView {
    func roundCorners(for corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(
            roundedRect: bounds,
            byRoundingCorners: corners,
            cornerRadii: .init(width: radius, height: radius)
        )
        
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}
