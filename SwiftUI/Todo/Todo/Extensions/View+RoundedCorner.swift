//
//  View+RoundedCorner.swift
//  Todo
//
//  Created by Le Hoang Anh on 09/03/2022.
//

import SwiftUI

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}
