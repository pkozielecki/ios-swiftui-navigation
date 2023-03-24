//
//  HomeView.swift
//  KISS Views
//

import SwiftUI

struct HomeView: View {
    @State private var navigationStack = [NavLink]()

    var body: some View {
        NavigationStack(
            path: .init(
                get: {
                    navigationStack
                },
                set: { stack in
                    navigationStack = stack
                }
            )
        ) {
                VStack(spacing: 30) {
                    Spacer()
                    Text("SwiftUI\nNavigation Showcase")
                        .font(.title)
                        .multilineTextAlignment(.center)
                        .bold()
                    Text("Tap a link to explore one of the options:")
                    Spacer()
                    VStack(spacing: 15) {
                        Divider()
                        NavigationLink(value: NavLink.swiftUIRouter) {
                            Text("Nav Stack + Router SwiftUI navigation")
                        }
                        Divider()
                        NavigationLink(value: NavLink.uikit) {
                            Text("UIKit navigation (UINavController + Router)")
                        }
                        Divider()
                        NavigationLink(value: NavLink.viewState) {
                            Text("View State (drill-down) navigation")
                        }
                        Divider()
                    }
                    Spacer()
                }
                .navigationDestination(for: NavLink.self) { navLink in
                    switch navLink {
                    case .uikit:
                        EmptyView()
                    case .viewState:
                        EmptyView()
                    case .swiftUIRouter:
                        EmptyView()
                    }
                }
        }
    }
}

extension HomeView {
    enum NavLink: Hashable {
        case uikit, viewState, swiftUIRouter
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
