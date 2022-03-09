//
//  DateButtonListView.swift
//  Todo
//
//  Created by Le Hoang Anh on 07/03/2022.
//

import SwiftUI

struct DateButtonListView: View {
    @Binding var selectedIndex: Int
    
    var body: some View {
        HStack {
            Spacer()
            
            ForEach(0..<DateManager.shared.daysOfWeek.count) { index in
                Button {
                    self.selectedIndex = index
                } label: {
                    VStack(spacing: 8) {
                        Text(getDayNumberAsString(for: index))
                            .font(.system(size: 15, weight: .bold))
                        Text(DateManager.shared.shortWeekdaySymbols[index])
                            .font(.system(size: 15, weight: .bold))
                        
                        Circle()
                            .fill(.white)
                            .frame(width: 8, height: 8)
                    }
                }
                .buttonStyle(DateButtonStyle(isSelected: selectedIndex == index))
                
                Spacer()
            }
        }
    }
    
    func getDayNumberAsString(for index: Int) -> String {
        let components = Calendar.current.dateComponents(
            in: .current,
            from: DateManager.shared.daysOfWeek[index]
        )
        
        return String(format: "%.2d", components.day ?? 1)
    }
}

struct DateButtonListView_Previews: PreviewProvider {
    static var previews: some View {
        DateButtonListView(
            selectedIndex: .constant(
                DateManager.shared.daysOfWeek.firstIndex { date in
                    Calendar.current.isDateInToday(date)
                } ?? 0
            )
        )
    }
}
