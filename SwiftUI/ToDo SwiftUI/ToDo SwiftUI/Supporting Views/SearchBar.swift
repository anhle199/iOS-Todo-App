//
//  SearchBarView.swift
//  ToDo SwiftUI
//
//  Created by Le Hoang Anh on 17/03/2022.
//

import SwiftUI

struct SearchBar: UIViewRepresentable {
    
    let placeholder: String
    @Binding var text: String
    @Binding var isShown: Bool
    @ObservedObject var homeViewModel: HomeViewModel
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIView(context: Context) -> UISearchBar {
        let searchBar = UISearchBar(frame: .zero)
        searchBar.searchBarStyle = .minimal
        searchBar.autocapitalizationType = .none
        searchBar.searchTextField.text = text
        searchBar.placeholder = placeholder
        searchBar.autocorrectionType = .no
        searchBar.showsCancelButton = true
        
        searchBar.delegate = context.coordinator
        
        return searchBar
    }
    
    func updateUIView(_ uiView: UISearchBar, context: Context) {
        uiView.text = text
    }
    
    class Coordinator: NSObject, UISearchBarDelegate {
        var parent: SearchBar
        
        init(_ searchBar: SearchBar) {
            self.parent = searchBar
        }
        
        func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
            // Hide search bar and show navigation bar
            parent.isShown = false
            parent.text = ""
            
            // Reload list of tasks and update bottom bar
            parent.homeViewModel.isValueChanged.toggle()
        }
        
        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            parent.text = searchText
            let taskTitle = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
            
            if !taskTitle.isEmpty {
                parent.homeViewModel.searchButtonClicked.toggle()
            } else {
                parent.homeViewModel.isValueChanged.toggle()
            }
        }
    }
}

struct SearchBar_Previews: PreviewProvider {
    static var previews: some View {
        SearchBar(
            placeholder: "Type a task title here",
            text: .constant(""),
            isShown: .constant(true),
            homeViewModel: HomeViewModel()
        )
        .frame(width: .infinity, height: 40)
    }
}
