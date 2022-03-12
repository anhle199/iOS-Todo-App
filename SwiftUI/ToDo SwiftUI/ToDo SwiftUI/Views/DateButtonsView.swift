//
//  DateButtonsView.swift
//  ToDo SwiftUI
//
//  Created by Le Hoang Anh on 11/03/2022.
//

import SwiftUI

struct DateButtonsView: View {
    @EnvironmentObject var viewModel: HomeViewModel
    
    var body: some View {
        HStack {
            Spacer()
            
            ForEach(0..<viewModel.countDates) { index in
                Button {
                    withAnimation(.easeIn(duration: 0.1)) {
                        viewModel.selectedDateIndex = index
                    }
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
                .buttonStyle(
                    DateButtonStyle(
                        isSelected: viewModel.selectedDateIndex == index
                    )
                )
                
                Spacer()
            }
        }
    }
    
    func getDayNumberAsString(for index: Int) -> String {
        let components = Calendar.current.dateComponents(
            in: .current,
            from: viewModel.daysOfWeek[index]
        )
        
        return String(format: "%.2d", components.day ?? 1)
    }
}

struct DateButtonsView_Previews: PreviewProvider {
    static var previews: some View {
        DateButtonsView()
            .environmentObject(HomeViewModel())
    }
}
