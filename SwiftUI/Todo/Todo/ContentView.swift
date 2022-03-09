//
//  ContentView.swift
//  Todo
//
//  Created by Le Hoang Anh on 06/03/2022.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedDateIndex = 0
    @State private var tasks = generateTaskData()
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                DateButtonListView(selectedIndex: $selectedDateIndex)
                    .padding(.vertical, 8)
                
                TaskListView(tasks: $tasks)
                    .padding(.bottom, 2)
                
                BottomBarView(
                    selectedDateIndex: $selectedDateIndex,
                    tasks: tasks
                )
            }
            .navigationTitle("Tasks")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(leading: leftBarItem, trailing: rightBarItems)
            .edgesIgnoringSafeArea(.bottom)
        }
        .navigationViewStyle(.stack)
        .onAppear {
            self.selectedDateIndex = DateManager.shared.getIndexOfTodayInWeek() ?? 0
        }
    }
    
    var leftBarItem: some View {
        Button {
            
        } label: {
            Image(systemName: Constants.IconName.filter)
                .foregroundColor(.black)
        }
    }
    
    var rightBarItems: some View {
        HStack {
            Button {
                
            } label: {
                Image(systemName: Constants.IconName.add)
            }

            Button {
                
            } label: {
                Image(systemName: Constants.IconName.search)
            }
        }
        .foregroundColor(.black)
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewInterfaceOrientation(.portrait)
    }
}
