//
//  TaskDetailView.swift
//  ToDo SwiftUI
//
//  Created by Le Hoang Anh on 14/03/2022.
//

import SwiftUI
import RealmSwift

struct TaskDetailView: View {
    @ObservedRealmObject var task: TaskItem
    @State private var draftTask = TaskItemNonRealmObject()
    @State private var editMode = EditMode.inactive
    @State private var showTextEditorPopup = false
    @State private var text = ""
    @State private var textFieldEditing: EditableFieldInTextEditorPopup?
    
    var onDelete: (TaskItem) -> Void
    @Environment(\.dismiss) var dismiss
    
    enum EditableFieldInTextEditorPopup {
        case title, description
    }
    
    var body: some View {
        ZStack(alignment: .center) {
            Form {
                Section {
                    Toggle("Completed", isOn: $draftTask.isDone)
                } header: {
                    Text("Status")
                }
                
                Section {
                    HStack {
                        Text("Task name")
                        
                        Spacer()
                        
                        TextField("", text: $draftTask.title)
                            .foregroundColor(.secondary)
                            .environment(\.layoutDirection, .rightToLeft)
                            .disabled(true)
                    }
                    
                    Toggle("Important", isOn: $draftTask.isImportant)
                } header: {
                    HStack {
                        Text("Basic")
                        Spacer()
                        Button("Open Editor") {
                            self.text = draftTask.title
                            self.textFieldEditing = .title
                            self.showTextEditorPopup = true
                        }
                    }
                }
                
                Section {
                    DatePicker(
                        "Due time",
                        selection: $draftTask.dueTime,
                        in: rangeDueTime,
                        displayedComponents: .hourAndMinute
                    )
                    DatePicker(
                        "Take place on",
                        selection: $draftTask.dueTime,
                        in: rangeDueTime,
                        displayedComponents: .date
                    )
                } header: {
                    Text("Due Date")
                }
                
                Section {
                    TextEditor(text: $draftTask.taskDescription)
                        .disabled(true)
                } header: {
                    HStack {
                        Text("Description")
                        Spacer()
                        Button("Open Editor") {
                            self.text = draftTask.taskDescription
                            self.textFieldEditing = .description
                            self.showTextEditorPopup = true
                        }
                    }
                }
            }
            
            if showTextEditorPopup {
                TextEditorPopup(
                    isPresented: $showTextEditorPopup,
                    text: $text,
                    isEditable: true
                )
                    .onDisappear {
                        switch textFieldEditing {
                        case .title:
                            self.draftTask.title = text
                        case .description:
                            self.draftTask.taskDescription = text
                        default:
                            break
                        }
                        
                        self.textFieldEditing = nil
                    }
            }
        }
        .navigationTitle(navigationTitle)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(isEditing)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                CancelButton()
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                if isEditing {
                    DoneButton()
                } else {
                    DeleteButton()
                }
            }
        }
        .onChange(of: draftTask) { newValue in
            let initialValue = TaskItemNonRealmObject(from: task)
            self.editMode = initialValue == newValue ? .inactive : .active
        }
        .onAppear {
            self.draftTask = .init(from: task)
        }
    }
    
    @ViewBuilder
    func CancelButton() -> some View {
        if isEditing {
            Button("Cancel") {
                self.rollback()
                self.editMode = .inactive
            }
            .disabled(showTextEditorPopup)
        }
    }
    
    @ViewBuilder
    func DoneButton() -> some View {
        Button {
            self.commit()
            self.editMode = .inactive
        } label: {
            Text("Done")
                .fontWeight(.semibold)
        }
        .disabled(showTextEditorPopup)
    }
    
    @ViewBuilder
    func DeleteButton() -> some View {
        Button {
            self.dismiss()
            self.onDelete(task)
        } label: {
            Image(systemName: "trash")
                .foregroundColor(.red)
        }
        .disabled(showTextEditorPopup)
    }
    
    var isEditing: Bool { editMode == .active }
    
    var navigationTitle: String {
        "Detail \(isEditing ? "(Editting)" : "")"
    }
    
    var rangeDueTime: ClosedRange<Date> {
        let dateManager = DateManager.shared
        let minDate = dateManager.startTime(of: dateManager.daysOfWeek.first ?? .now)
        let maxDate = dateManager.startTime(of: dateManager.daysOfWeek.last ?? .now)
        
        return minDate...maxDate
    }
    
    func commit() {
        self.$task.title.wrappedValue = draftTask.title
        self.$task.taskDescription.wrappedValue = draftTask.taskDescription
        self.$task.dueTime.wrappedValue = draftTask.dueTime
        self.$task.isImportant.wrappedValue = draftTask.isImportant
        self.$task.isDone.wrappedValue = draftTask.isDone
        self.$task.createdAt.wrappedValue = draftTask.createdAt
    }
    
    func rollback() {
        self.draftTask = .init(from: task)
    }
    
}

struct TaskDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            TaskDetailView(task: .init(), onDelete: { _ in })
        }
        .navigationViewStyle(.stack)
    }
}
