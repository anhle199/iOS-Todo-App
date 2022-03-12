//
//  TaskListViewTemp.swift
//  ToDo SwiftUI
//
//  Created by Le Hoang Anh on 12/03/2022.
//

import SwiftUI

fileprivate func generateTaskData() -> [TaskItem] {
    let formatter = DateFormatter()
    formatter.dateFormat = "dd/MM/yyyy HH:mm:ss"

    var tasks = [TaskItem]()
    
    for i in 0..<10 {
        let task = TaskItem()
        task.title = "Task \(i + 1)"
        task.taskDescription = "This is the description of this task."
        task.dueTime = formatter.date(from: "12/03/2022 19:09:00")!
        task.isImportant = false
        task.isDone = false
        task.createdAt = .now
        tasks.append(task)
    }

    return tasks
}


struct TaskListViewTemp: View {
    let tasks = generateTaskData()
    @State private var isClickedTaskRow = false
    @State private var selectedTaskIndex: Int? = nil
    
    var body: some View {
        ZStack {
            NavigationLink("", isActive: $isClickedTaskRow) {
                if let index = selectedTaskIndex {
                    Text(tasks[index].title)
                } else {
                    Text("No tasks")
                }
                
            }
            
            ScrollView {
                ForEach(tasks) { task in
                    TaskRowTemp(task: task)
                }
                .padding(.horizontal, 12)
            }
        }
    }
}

struct TaskListViewTemp_Previews: PreviewProvider {
    static var previews: some View {
        TaskListViewTemp()
    }
}
