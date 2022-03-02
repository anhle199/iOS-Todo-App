//
//  UIView+Extensions.swift
//  Todo
//
//  Created by Le Hoang Anh on 26/02/2022.
//

import UIKit

extension UIView {
    
    enum CornerPosition {
        case topLeft
        case topRight
        case bottomLeft
        case bottomRight
        case all
        
        var rawValue: CACornerMask {
            switch self {
            case .topLeft:
                return .layerMinXMinYCorner
            case .topRight:
                return .layerMaxXMinYCorner
            case .bottomLeft:
                return .layerMinXMaxYCorner
            case .bottomRight:
                return .layerMaxXMaxYCorner
            case .all:
                return [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            }
        }
    }
    
    func makeRoundCorners(for corners: [CornerPosition], radius: CGFloat) {
        var maskedCorners = CACornerMask()
        corners.forEach({ maskedCorners.formUnion($0.rawValue) })
    
        self.layer.maskedCorners = maskedCorners
        self.layer.cornerRadius = radius
    }
    
    func makeRoundCorners(for corners: CornerPosition, radius: CGFloat) {
        self.layer.maskedCorners = corners.rawValue
        self.layer.cornerRadius = radius
    }
    
}
