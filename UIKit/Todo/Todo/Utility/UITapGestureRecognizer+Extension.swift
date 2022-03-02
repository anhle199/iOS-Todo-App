//
//  UITapGestureRecognizer+Extension.swift
//  Todo
//
//  Created by Le Hoang Anh on 02/03/2022.
//

import UIKit

extension UITapGestureRecognizer {
    
    func didTapInside(of view: UIView) -> Bool {
        return !didTapOutside(of: view)
    }
    
    func didTapOutside(of view: UIView) -> Bool {
        let location = self.location(in: view)
        let isSatisfiedX = (location.x < view.bounds.minX || location.x > view.bounds.maxX)
        let isSatisfiedY = (location.y < view.bounds.minY || location.y > view.bounds.maxY)
        
        return isSatisfiedX || isSatisfiedY
    }
    
}
