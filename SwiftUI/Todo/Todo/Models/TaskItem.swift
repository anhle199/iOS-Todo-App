//
//  TaskItem.swift
//  Todo
//
//  Created by Le Hoang Anh on 09/03/2022.
//

import Foundation

struct TaskItem: Hashable {
    var title: String
    var taskDescription: String
    var dueTime: Date
    var isImportant: Bool
    var isDone: Bool
    var createdAt: Date
}

func generateTaskData() -> [TaskItem] {
    let formatter = DateFormatter()
    formatter.dateFormat = "dd/MM/yyyy HH:mm:ss"
    
    return [
        TaskItem(
            title: "This is the first task item in the list of tasks",
            taskDescription: "sjkdnkjasndkasjndjkansdjknaskdjnaskjdnaskjndjkasndkjasnduiqwndjsnadjkansdjkansjkdnaskjdnasjkdnajksnajksdn",
            dueTime: formatter.date(from: "25/2/2022 19:09:00")!,
            isImportant: false,
            isDone: false,
            createdAt: .now
        ),
        TaskItem(
            title: "This is the second task item in the list of tasks",
            taskDescription: "sjkdnkjasndkasjndjkansdjknaskdjnaskjdnaskjndjkasndkjasnduiqwndjsnadjkansdjkansjkdnaskjdnasjkdnajksnajksdn",
            dueTime: formatter.date(from: "25/2/2022 23:59:59")!,
            isImportant: true,
            isDone: false,
            createdAt: .now
        ),
        TaskItem(
            title: "This is the third task item in the list of tasks",
            taskDescription: "sjkdnkjasndkasjndjkansdjknaskdjnaskjdnaskjndjkasndkjasnduiqwndjsnadjkansdjkansjkdnaskjdnasjkdnajksnajksdn",
            dueTime: formatter.date(from: "26/2/2022 18:59:00")!,
            isImportant: false,
            isDone: false,
            createdAt: .now
        ),
        TaskItem(
            title: "This is the fourth task item in the list of tasks",
            taskDescription: "sjkdnkjasndkasjndjkansdjknaskdjnaskjdnaskjndjkasndkjasnduiqwndjsnadjkansdjkansjkdnaskjdnasjkdnajksnajksdn",
            dueTime: formatter.date(from: "26/2/2022 20:34:00")!,
            isImportant: false,
            isDone: false,
            createdAt: .now
        ),
        TaskItem(
            title: "This is the fifth task item in the list of tasks",
            taskDescription: "sjkdnkjasndkasjndjkansdjknaskdjnaskjdnaskjndjkasndkjasnduiqwndjsnadjkansdjkansjkdnaskjdnasjkdnajksnajksdn",
            dueTime: formatter.date(from: "26/2/2022 14:10:00")!,
            isImportant: true,
            isDone: false,
            createdAt: .now
        ),
        TaskItem(
            title: "This is the sixth task item in the list of tasks",
            taskDescription: "sjkdnkjasndkasjndjkansdjknaskdjnaskjdnaskjndjkasndkjasnduiqwndjsnadjkansdjkansjkdnaskjdnasjkdnajksnajksdn",
            dueTime: formatter.date(from: "26/2/2022 23:59:59")!,
            isImportant: false,
            isDone: true,
            createdAt: .now
        ),
        TaskItem(
            title: "This is the seventh task item in the list of tasks",
            taskDescription: "sjkdnkjasndkasjndjkansdjknaskdjnaskjdnaskjndjkasndkjasnduiqwndjsnadjkansdjkansjkdnaskjdnasjkdnajksnajksdn",
            dueTime: formatter.date(from: "26/2/2022 05:00:00")!,
            isImportant: true,
            isDone: true,
            createdAt: .now
        ),
        TaskItem(
            title: "This is the eighth task item in the list of tasks",
            taskDescription: "sjkdnkjasndkasjndjkansdjknaskdjnaskjdnaskjndjkasndkjasnduiqwndjsnadjkansdjkansjkdnaskjdnasjkdnajksnajksdn",
            dueTime: formatter.date(from: "27/2/2022 22:00:00")!,
            isImportant: true,
            isDone: false,
            createdAt: .now
        ),
        TaskItem(
            title: "This is the nineth task item in the list of tasks",
            taskDescription: "sjkdnkjasndkasjndjkansdjknaskdjnaskjdnaskjndjkasndkjasnduiqwndjsnadjkansdjkansjkdnaskjdnasjkdnajksnajksdn",
            dueTime: formatter.date(from: "27/2/2022 23:00:00")!,
            isImportant: false,
            isDone: true,
            createdAt: .now
        ),
        TaskItem(
            title: "This is the tenth task item in the list of tasks",
            taskDescription: "sjkdnkjasndkasjndjkansdjknaskdjnaskjdnaskjndjkasndkjasnduiqwndjsnadjkansdjkansjkdnaskjdnasjkdnajksnajksdn",
            dueTime: formatter.date(from: "27/2/2022 10:00:00")!,
            isImportant: false,
            isDone: false,
            createdAt: .now
        ),
        TaskItem(
            title: "This is the eleventh task item in the list of tasks",
            taskDescription: "sjkdnkjasndkasjndjkansdjknaskdjnaskjdnaskjndjkasndkjasnduiqwndjsnadjkansdjkansjkdnaskjdnasjkdnajksnajksdn",
            dueTime: formatter.date(from: "27/2/2022 22:00:00")!,
            isImportant: false,
            isDone: false,
            createdAt: .now
        ),
    ]
}
