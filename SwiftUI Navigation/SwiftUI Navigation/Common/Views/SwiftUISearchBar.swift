//
//  SwiftUISearchBar.swift
//  KISS Views
//

import SwiftUI
import UIKit

/// A UIKit Searchbar wrapped in SwiftUI View
/// - SeeAlso: https://axelhodler.medium.com/creating-a-search-bar-for-swiftui-e216fe8c8c7f
struct SwiftUISearchBar: UIViewRepresentable {
    @Binding var text: String

    class Coordinator: NSObject, UISearchBarDelegate {
        @Binding var text: String

        init(text: Binding<String>) {
            _text = text
        }

        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            text = searchText
        }
    }

    func makeCoordinator() -> SwiftUISearchBar.Coordinator {
        Coordinator(text: $text)
    }

    func makeUIView(context: UIViewRepresentableContext<SwiftUISearchBar>) -> UISearchBar {
        let searchBar = UISearchBar(frame: .zero)
        searchBar.delegate = context.coordinator
        searchBar.searchBarStyle = .minimal
        return searchBar
    }

    func updateUIView(_ uiView: UISearchBar, context: UIViewRepresentableContext<SwiftUISearchBar>) {
        uiView.text = text
    }
}
