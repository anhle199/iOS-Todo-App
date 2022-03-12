//
//  FilterView.swift
//  ToDo SwiftUI
//
//  Created by Le Hoang Anh on 12/03/2022.
//

import SwiftUI

struct FilterView: View {
    @Binding var isPresented: Bool
    @State private var showUncomplete = false
    @State private var showCompleted = false
    @State private var showImportant = false
    
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
                    
                } label: {
                    Text("Apply")
                        .font(.system(size: 17, weight: .semibold))
                }
                
            }
            .padding(.horizontal, 16)
            .frame(height: 40, alignment: .center)
            .background(Color.gray.opacity(0.4))
            .cornerRadius(24, corners: [.topLeft, .topRight])
            
            VStack(spacing: 16) {
                Group {
                    Toggle(isOn: $showUncomplete) {
                        Text("Uncomplete")
                    }
                    
                    Toggle(isOn: $showCompleted) {
                        Text("Completed")
                    }
                    
                    Toggle(isOn: $showImportant) {
                        Text("Important")
                    }
                }
                .makeFilterToggleStyle()
               
                Text("The default filter values are both Uncomplete and Completed are on.")
                    .foregroundColor(.secondary)
                    .font(.system(size: 13, weight: .medium))
            }
            .padding(.top, 20)
            .padding(.bottom, 32)
            .background(Color.black.opacity(0.05))
        }
    }
}

struct FilterView_Previews: PreviewProvider {
    static var previews: some View {
        FilterView(isPresented: .constant(false))
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
