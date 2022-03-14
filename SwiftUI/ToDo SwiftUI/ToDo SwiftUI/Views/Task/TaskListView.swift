//
//  TaskListView.swift
//  ToDo SwiftUI
//
//  Created by Le Hoang Anh on 11/03/2022.
//

import SwiftUI
import RealmSwift

struct TaskListView: View {
    @ObservedResults(TaskItem.self) var tasks
    @EnvironmentObject var viewModel: HomeViewModel
    
    @State private var isClickedTaskRow = false
    @State private var selectedTaskIndex: Int? = nil
    
    var body: some View {
        ZStack {
            NavigationLink("", isActive: $isClickedTaskRow) {
                if let index = selectedTaskIndex {
                    TaskDetailView(task: tasks[index])
                } else {
                    Text("No data")
                }
                
            }
            
            ScrollView {
                ForEach(viewModel.displayedTasks) { task in
                    if let index = tasks.firstIndex(
                        where: { $0.id == task.id }
                    ) {
                        TaskRow(
                            task: tasks[index],
                            isValueChanged: $viewModel.isValueChanged
                        )
                        .onTapGesture {
                            self.selectedTaskIndex = index
                            self.isClickedTaskRow = true
                        }
                    }
                }
                .padding(.horizontal, 12)
            }
        }
    }
    
}

struct TaskListView_Previews: PreviewProvider {
    static var previews: some View {
        TaskListView()
            .environmentObject(HomeViewModel())
    }
}
