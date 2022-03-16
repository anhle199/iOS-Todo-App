//
//  HomeView.swift
//  ToDo SwiftUI
//
//  Created by Le Hoang Anh on 11/03/2022.
//

import SwiftUI
import RealmSwift

struct HomeView: View {
    @ObservedResults(TaskItem.self) var tasks
    @EnvironmentObject var viewModel: HomeViewModel
    
    @State private var showFilterView = false
    @State private var initialStatuses: Set<TaskStatus> = [.uncomplete, .completed]
    @State private var predicate: NSPredicate? = nil
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottom) {
                VStack(spacing: 0) {
                    DateButtonsView()
                        .padding(.vertical, 8)
                        .environmentObject(viewModel)
                        .onAppear {
                            viewModel.resetDateIndexToToday()
                        }
                    
                    TaskListView()
                        .environmentObject(viewModel)
                        .padding(.bottom, 2)
//                    TaskListViewTemp()
//                        .padding(.bottom, 2)
                    
                    if !showFilterView {
                        BottomBarView()
                            .environmentObject(viewModel)
                    }
                }
                
                if showFilterView {
                    ZStack(alignment: .bottom) {
                        Color.black
                            .opacity(0.7)
                            .ignoresSafeArea()
                            .onTapGesture {
                                self.showFilterView = false
                            }
                        
                        FilterView(
                            isPresented: $showFilterView,
                            initialStatuses: $initialStatuses,
                            predicate: $viewModel.predicate
                        )
                    }
                }
            }
            .navigationTitle("Tasks")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    leadingBarItem
                        .disabled(showFilterView)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    trailingBarItems
                        .disabled(showFilterView)
                }
            }
            .edgesIgnoringSafeArea(.bottom)
            .onChange(of: viewModel.selectedDateIndex) { _ in
                viewModel.filterAndSortTasks(from: tasks)
            }
            .onChange(of: viewModel.isValueChanged) { _ in
                viewModel.filterAndSortTasks(from: tasks)
            }
            .onChange(of: tasks.count) { _ in
                viewModel.filterAndSortTasks(from: tasks)
            }
            .onChange(of: viewModel.predicate) { newValue in
                viewModel.filterAndSortTasks(from: tasks)
            }
        }
        .navigationViewStyle(.stack)
    }
    
    var leadingBarItem: some View {
        Button {
            self.showFilterView = true
        } label: {
            Image(systemName: Constants.IconName.filter)
                .foregroundColor(.black)
        }
    }
    
    var trailingBarItems: some View {
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

//struct HomeView_Previews: PreviewProvider {
//    static var previews: some View {
//        HomeView()
//            .environmentObject(HomeViewModel())
//    }
//}
