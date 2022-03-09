//
//  TaskListView.swift
//  Todo
//
//  Created by Le Hoang Anh on 09/03/2022.
//

import SwiftUI

struct TaskListView: View {
    
    @Binding var tasks: [TaskItem]
    @State private var isClickedTaskRow = false
    @State private var selectedTaskRowIndex: Int? = nil
    
    var body: some View {
        ZStack {
            NavigationLink("", isActive: $isClickedTaskRow) {
                Text("\(selectedTaskRowIndex ?? -1)")
            }
            
            ScrollView {
                ForEach(0..<tasks.count, id: \.self) { index in
                    TaskRowView(for: index)
                        .onTapGesture {
                            self.selectedTaskRowIndex = index
                            self.isClickedTaskRow = true
                        }
                }
                .padding(.horizontal, 12)
            }
        }
        
    }
    
    @ViewBuilder
    func TaskRowView(for index: Int) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                Text(tasks[index].title)
                    .font(.system(size: 24, weight: .bold))
                    .lineLimit(1)
                    .foregroundColor(
                        Color(UIColor.systemBackground)
                    )
                
                Text(tasks[index].taskDescription)
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
                Text(tasks[index].dueTime, style: .time)
                    .font(.system(size: 17, weight: .semibold))
                    .lineLimit(1)
                    .foregroundColor(
                        Color(UIColor.systemBackground)
                    )
                
                HStack(spacing: 16) {
                    ImportantIconButton(forBinding: $tasks[index])
                    CompletionIconButton(forBinding: $tasks[index])
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
    
    @ViewBuilder
    func ImportantIconButton(forBinding task: Binding<TaskItem>) -> some View {
        let iconName = task.wrappedValue.isImportant
        ? Constants.IconName.star.marked
        : Constants.IconName.star.unmark
        
        Button {
            task.wrappedValue.isImportant.toggle()
        } label: {
            Image(systemName: iconName)
                .foregroundColor(.yellow)
        }
    }
    
    @ViewBuilder
    func CompletionIconButton(forBinding task: Binding<TaskItem>) -> some View {
        let iconName = task.wrappedValue.isDone
        ? Constants.IconName.checkmark.marked
        : Constants.IconName.checkmark.unmark
        
        Button {
            task.wrappedValue.isDone.toggle()
        } label: {
            Image(systemName: iconName)
                .foregroundColor(
                    Color(UIColor.systemBackground)
                )
        }
    }
    
}

struct TaskListView_Previews: PreviewProvider {
    static var previews: some View {
        TaskListView(tasks: .constant(generateTaskData()))
    }
}
