//
//  TextEditorPopup.swift
//  ToDo SwiftUI
//
//  Created by Le Hoang Anh on 14/03/2022.
//

import SwiftUI

struct TextEditorPopup: View {
    
    // Binding variable indicates whether show or hide this popup view.
    @Binding var isPresented: Bool
    // State variable indicates whether show or hide the warning alert.
    @State private var showAlert = false
    
    @Binding var text: String  // initial text
    @State private var draftText = ""
    
    // Variable indicates whether the passed text is editable or not.
    let isEditable: Bool
    
    // Variables indicate editing mode or focus status of text editor.
    @State private var editMode = EditMode.inactive
    @FocusState private var isFocused: Bool
    
    
    // MARK: - Body
    var body: some View {
        ZStack {
            // Dimming view
            Color.black
                .opacity(0.7)
                .onTapGesture {
                    if isEditing && hasChangeText {
                        self.showAlert = true
                    } else {
                        self.isPresented = false
                    }
                }
                .ignoresSafeArea()
                .alert(
                    "Are you sure want to close this popup?",
                    isPresented: $showAlert
                ) {
                    NoButton()
                    YesButton()
                } message: {
                    Text("Your changes will be removed if you close this popup.")
                }

            // Editor Popup
            VStack(spacing: 0) {
                HStack {
                    CloseOrCancelButton()
                    
                    Spacer()
                    
                    Text("Task Name")
                        .font(.headline)
                    
                    Spacer()
                    
                    if isEditable {
                        EditOrDoneButton()
                    }
                }
                .padding(.horizontal, 16)
                .frame(height: 40)
                .background(Color(uiColor: .systemGray3))
                
                TextEditor(text: $draftText)
                    .disabled(!isEditable)
                    .focused($isFocused)
                    .disableAutocorrection(true)
                    .cornerRadius(8)
                    .shadow(color: .gray, radius: 0.5, x: 0, y: 0)
                    .padding(8)
                    .background(Color(uiColor: .systemGray5))
                    .onTapGesture {
                        if isEditable {
                            self.editMode = .active
                        }
                    }
            }
            .frame(
                width: UIScreen.main.bounds.width * 0.75,
                height: UIScreen.main.bounds.height * 0.5,
                alignment: .center
            )
            .cornerRadius(16)
        }
        .onAppear { self.draftText = text }
    }
    
    
    // MARK: - View Builders
    @ViewBuilder
    func NoButton() -> some View {
        Button("No", role: .cancel) {
            self.showAlert = false
        }
    }
    
    @ViewBuilder
    func YesButton() -> some View {
        Button("Yes", role: .destructive) {
            self.showAlert = false
            
            self.draftText = text
            self.toggleEditModeValue()
            self.isFocused = false
            
            self.isPresented = false
        }
    }
    
    @ViewBuilder
    func CloseOrCancelButton() -> some View {
        Button {
            if isEditing {  // Cancel's action
                self.draftText = text
                self.toggleEditModeValue()
                self.isFocused = false
            } else {  // Close action
                self.isPresented = false
            }
        } label: {
            Text(isEditing ? "Cancel" : "Close")
        }
    }
    
    @ViewBuilder
    func EditOrDoneButton() -> some View {
        Button {
            if isEditing {
                self.text = draftText
            }
            
            self.toggleEditModeValue()
            self.isFocused.toggle()
        } label: {
            Text(isEditing ? "Done" : "Edit")
                .fontWeight(isEditing ? .semibold : .none)
                .disabled(isEditing ? !hasChangeText : false)
        }
    }
    
    
    // MARK: - Others
    var hasChangeText: Bool { draftText != text }
    
    var isEditing: Bool { editMode == .active }
    
    func toggleEditModeValue() {
        self.editMode = (editMode == .active) ? .inactive : .active
    }
    
}

struct TextEditorPopup_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            TextEditorPopup(
                isPresented: .constant(false),
                text: .constant("Text"),
                isEditable: false
            )
        }
    }
}
