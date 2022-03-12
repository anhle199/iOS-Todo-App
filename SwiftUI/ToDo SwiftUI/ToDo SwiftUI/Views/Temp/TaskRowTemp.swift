//
//  TaskRowTemp.swift
//  ToDo SwiftUI
//
//  Created by Le Hoang Anh on 12/03/2022.
//

import SwiftUI

struct TaskRowTemp: View {
    var task: TaskItem
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                Text(task.title)
                    .font(.system(size: 24, weight: .bold))
                    .lineLimit(1)
                    .foregroundColor(
                        Color(UIColor.systemBackground)
                    )
                
                Text(task.taskDescription)
                    .font(.system(size: 15))
                    .foregroundColor(
                        Color(
                            UIColor.systemBackground
                                .withAlphaComponent(0.5)
                        )
                    )
                    .lineLimit(1)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 8) {
                Text(task.dueTime, style: .time)
                    .font(.system(size: 17, weight: .semibold))
                    .lineLimit(1)
                    .foregroundColor(
                        Color(UIColor.systemBackground)
                    )
                
                HStack(spacing: 16) {
                    TaskStatusToggleButton(task, statusType: .important)
                    TaskStatusToggleButton(task, statusType: .completion)
                }
                .font(Font.title2)
            }
            .frame(width: 80, alignment: .trailing)
        }
        .padding(.vertical, 16)
        .padding(.horizontal, 16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.black)
        )
        .frame(height: 90)
    }
    
    enum TaskStatusType {
        case important
        case completion
    }
    
    @ViewBuilder
    func TaskStatusToggleButton(
        _ task: TaskItem,
        statusType: TaskStatusType
    ) -> some View {
        if statusType == .important {
            Button {
               
            } label: {
                let iconName = task.isImportant
                ? Constants.IconName.star.marked
                : Constants.IconName.star.unmark
                
                Image(systemName: iconName)
                    .foregroundColor(.yellow)
            }
        } else {
            Button {
                
            } label: {
                let iconName = task.isDone
                ? Constants.IconName.checkmark.marked
                : Constants.IconName.checkmark.unmark
                
                Image(systemName: iconName)
                    .foregroundColor(.init(.systemBackground))
            }
        }
    }
}
