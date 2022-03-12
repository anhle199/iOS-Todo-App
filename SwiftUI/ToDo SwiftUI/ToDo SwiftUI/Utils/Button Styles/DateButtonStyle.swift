//
//  DateButtonStyle.swift
//  ToDo SwiftUI
//
//  Created by Le Hoang Anh on 11/03/2022.
//

import SwiftUI

struct DateButtonStyle: ButtonStyle {
    
    private let foregroundColor: Color
    private let backgroundColor: Color
    
    init(isSelected: Bool) {
        self.foregroundColor = isSelected ? .white : .secondary
        self.backgroundColor = isSelected ? .black : .white
    }
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(foregroundColor)
            .frame(width: 45, height: 90)
            .background(
                Capsule()
                    .fill(backgroundColor)
            )
    }
    
}
