//
//  RoundedCorner.swift
//  Todo
//
//  Created by Le Hoang Anh on 09/03/2022.
//

import SwiftUI

struct RoundedCorner: Shape {
    
    var radius: CGFloat = 0
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: .init(width: radius, height: radius)
        )
        
        return Path(path.cgPath)
    }
    
}
