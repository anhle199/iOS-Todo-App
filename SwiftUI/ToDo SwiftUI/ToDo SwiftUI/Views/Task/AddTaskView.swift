//
//  AddTaskView.swift
//  ToDo SwiftUI
//
//  Created by Le Hoang Anh on 16/03/2022.
//

import SwiftUI
import RealmSwift

struct AddTaskView: View {
    
    @State private var draftTask = TaskItemNonRealmObject()
    @State private var showTextEditorPopup = false
    @State private var text = ""
    @State private var textFieldEditing: EditableFieldInTextEditorPopup?
    @State private var showErrorAlert = false
    
    @Environment(\.dismiss) var dismiss
    
    enum EditableFieldInTextEditorPopup {
        case title, description
    }
    
    var body: some View {
        ZStack(alignment: .center) {
            VStack(spacing: 0) {
                HStack {
                    CancelButton()
                    
                    Spacer()
                    
                    Text("New Task")
                        .font(.headline)
                    
                    Spacer()
                    
                    DoneButton()
                }
                .padding(.horizontal, 16)
                .frame(height: 44)
                .background(Color(uiColor: .systemGray5))
                .alert("Add Task Unsucessfully", isPresented: $showErrorAlert) {
                    Button("Cancel", role: .cancel) {
                        self.showErrorAlert = false
                    }
                } message: {
                    Text("Cannot add a new task because the connection has an issue.")
                }

                
                Form {
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
    }
    
    @ViewBuilder
    func CancelButton() -> some View {
        Button("Cancel") {
            self.dismiss()
        }
        .disabled(showTextEditorPopup)
    }
    
    @ViewBuilder
    func DoneButton() -> some View {
        Button {
            self.addTask()
            self.dismiss()
        } label: {
            Text("Done")
                .fontWeight(.semibold)
        }
        .disabled(showTextEditorPopup)
    }

    var rangeDueTime: ClosedRange<Date> {
        let dateManager = DateManager.shared
        let minDate = dateManager.startTime(of: dateManager.daysOfWeek.first ?? .now)
        let maxDate = dateManager.startTime(of: dateManager.daysOfWeek.last ?? .now)
        
        return minDate...maxDate
    }
    
    func addTask() {
        do {
            let realm = try Realm()
            try realm.write {
                let newTask = TaskItem(from: draftTask)
                realm.add(newTask)
            }
        } catch {
            self.showErrorAlert = true
        }
    }
}

struct AddTaskView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            VStack {
                Text("Text")
                    .sheet(isPresented: .constant(true)) {
                        AddTaskView()
                    }
            }
        }
    }
}
