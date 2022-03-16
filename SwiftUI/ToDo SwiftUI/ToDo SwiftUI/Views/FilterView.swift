//
//  FilterView.swift
//  ToDo SwiftUI
//
//  Created by Le Hoang Anh on 12/03/2022.
//

import SwiftUI

struct FilterView: View {
    @Binding var isPresented: Bool
    @Binding var initialStatuses: Set<TaskStatus>
    @Binding var predicate: NSPredicate?
    
    @ObservedObject private var viewModel = FilterViewModel()
    
    var isDisabledApplyButton: Bool {
        viewModel.isDisabledApplyButton(
            withInitialStatuses: initialStatuses
        )
    }
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Button {
                    self.isPresented = false
                } label: {
                    Text("Close")
                        .font(.system(size: 17, weight: .semibold))
                }
                
                Spacer()
                
                Text("Filter")
                    .font(.system(size: 20, weight: .semibold))
                
                Spacer()
                
                Button {
                    self.isPresented = false
                    self.initialStatuses = viewModel.selectedStatuses
                    self.predicate = viewModel.createPrecidateFormat()
                } label: {
                    Text("Apply")
                        .font(.system(size: 17, weight: .semibold))
                }
                .disabled(isDisabledApplyButton)
                .foregroundColor(isDisabledApplyButton ? .gray : .blue)
            }
            .padding(.horizontal, 16)
            .frame(height: 40, alignment: .center)
            .background(Color(uiColor: .systemGray4))
            .cornerRadius(24, corners: [.topLeft, .topRight])
            
            VStack(spacing: 16) {
                Group {
                    Toggle("Uncomplete", isOn: $viewModel.showUncomplete)
                        .onChange(of: viewModel.showUncomplete) { _ in
                            viewModel.onValueChanged(with: .uncomplete)
                        }
                    
                    Toggle("Completed", isOn: $viewModel.showCompleted)
                        .onChange(of: viewModel.showCompleted) { _ in
                            viewModel.onValueChanged(with: .completed)
                        }
                    
                    Toggle("Important", isOn: $viewModel.showImportant)
                        .onChange(of: viewModel.showImportant) { _ in
                            viewModel.onValueChanged(with: .important)
                        }
                }
                .makeFilterToggleStyle()
               
                Text("The default filter values are both Uncomplete and Completed are on.")
                    .foregroundColor(.secondary)
                    .font(.system(size: 13, weight: .medium))
            }
            .padding(.top, 20)
            .padding(.bottom, 32)
            .background(Color(uiColor: .systemBackground))
        }
        .onAppear {
            viewModel.resetFilterValues(withInitialValues: initialStatuses)
        }
    }
    
}

struct FilterView_Previews: PreviewProvider {
    static var previews: some View {
        FilterView(
            isPresented: .constant(false),
            initialStatuses: .constant([]),
            predicate: .constant(nil)
        )
    }
}

extension View {
    func makeFilterToggleStyle() -> some View {
        padding(.vertical, 8)
        .padding(.horizontal, 16)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.8), radius: 2, x: 0, y: 0)
        .padding(.horizontal, 12)
    }
}
