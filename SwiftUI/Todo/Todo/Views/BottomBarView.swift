//
//  BottomBarView.swift
//  Todo
//
//  Created by Le Hoang Anh on 09/03/2022.
//

import SwiftUI

struct BottomBarView: View {
    @Binding var selectedDateIndex: Int
    let tasks: [TaskItem]
    
    var body: some View {
        HStack {
            Text(taskCountStatsFormatted)
            
            Spacer()
            
            Text(
                DateManager.shared.daysOfWeek[selectedDateIndex],
                formatter: DateManager.shared.getDateFormatter(
                    withDateStyle: .medium
                )
            )
        }
        .font(.system(size: 16, weight: .semibold))
        .padding(.vertical, 10)
        .padding(.horizontal, 12)
        .frame(height: 70, alignment: .top)
        .background(Color(uiColor: .lightGray))
        .cornerRadius(20, corners: [.topLeft, .topRight])
    }
    
    var taskCountStatsFormatted: String {
        let totalTasks = tasks.count
        let completedTasksCount = tasks.filter({ $0.isDone }).count
        
        return totalTasks == 0 ? "No tasks" : "\(totalTasks) tasks / \(completedTasksCount) completed"
    }
}

struct BottomBarView_Previews: PreviewProvider {
    static var previews: some View {
        BottomBarView(selectedDateIndex: .constant(0), tasks: generateTaskData())
    }
}
