//
//  BottomBarView.swift
//  ToDo SwiftUI
//
//  Created by Le Hoang Anh on 11/03/2022.
//

import SwiftUI
import RealmSwift

struct BottomBarView: View {
    @EnvironmentObject var viewModel: HomeViewModel
    
    var body: some View {
        HStack {
            Text(viewModel.taskCountStatWithFormatting)
            
            Spacer()
            
            Text(
                viewModel.selectedDate,
                formatter: viewModel.dateFormatterInMediumStyle
            )
        }
        .font(.system(size: 14, weight: .semibold))
        .padding(.vertical, 10)
        .padding(.horizontal, 12)
        .frame(height: 70, alignment: .top)
        .background(Color(uiColor: .lightGray))
        .cornerRadius(20, corners: [.topLeft, .topRight])
    }
}

struct BottomBarView_Previews: PreviewProvider {
    static var previews: some View {
        BottomBarView()
            .environmentObject(HomeViewModel())
    }
}
