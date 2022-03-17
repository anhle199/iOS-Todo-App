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
    
    @State private var showConfirmationDialog = false
    
    var body: some View {
        ZStack {
            NavigationLink("", isActive: $isClickedTaskRow) {
                if let index = selectedTaskIndex {
                    TaskDetailView(task: tasks[index], onDelete: deleteTask)
                        .onChange(of: tasks[index]) { _ in
                            self.viewModel.isValueChanged.toggle()
                        }
                        .onDisappear {
                            self.selectedTaskIndex = nil
                            self.viewModel.needsToResetDateIndex = true
                        }
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
                            self.viewModel.needsToResetDateIndex = false
                        }
                        .onLongPressGesture {
                            self.selectedTaskIndex = index
                            self.showConfirmationDialog = true
                        }
                    }
                }
                .padding(.horizontal, 12)
                .confirmationDialog(
                    "What do you want to perform with this task?",
                    isPresented: $showConfirmationDialog,
                    titleVisibility: .visible
                ) {
                    CancelButton()
                    DeleteButton()
                }
            }
        }
    }
 
    func deleteTask(_ task: TaskItem) {
        self.$tasks.remove(task)
        self.selectedTaskIndex = nil
    }
    
    @ViewBuilder
    func CancelButton() -> some View {
        Button("Cancel", role: .cancel) {
            self.selectedTaskIndex = nil
            self.showConfirmationDialog = false
        }
    }
    
    @ViewBuilder
    func DeleteButton() -> some View {
        Button("Delete", role: .destructive) {
            self.deleteTask(tasks[selectedTaskIndex!])
            self.showConfirmationDialog = false
        }
    }
    
}

struct TaskListView_Previews: PreviewProvider {
    static var previews: some View {
        TaskListView()
            .environmentObject(HomeViewModel())
    }
}
