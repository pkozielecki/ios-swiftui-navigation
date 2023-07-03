//
//  HomeView.swift
//  KISS Views
//

import SwiftUI

// private var dependencyProvider: DependencyProvider?

struct HomeView: View {
    @State private var isSwiftUINaviPresented = false
    @State private var isUIKitNaviPresented = false

    var body: some View {
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
                Button("Nav Stack + Router SwiftUI navigation") {
                    isSwiftUINaviPresented.toggle()
                }
                .fullScreenCover(isPresented: $isSwiftUINaviPresented) {
                    let router = DefaultSwiftUINavigationRouter()
                    SwiftUIRouterHomeView(
                        viewModel: DefaultSwiftUIRouterHomeViewModel(
                            favouriteAssetsManager: DefaultFavouriteAssetsManager(),
                            router: router
                        ),
                        router: router
                    )
                }

                Divider()
                Button("UIKit navigation (UINavController + Router)") {
                    isUIKitNaviPresented.toggle()
                }
                .fullScreenCover(isPresented: $isUIKitNaviPresented) {
                    let rootViewController = RootViewController {
                        isUIKitNaviPresented = false
                    }
                    let dependencyProvider = DefaultDependencyProvider(rootAppNavigator: rootViewController)
                    UIKitRouterHomeView(dependencyProvider: dependencyProvider, rootViewController: rootViewController)
                }

                Divider()
            }

            Spacer()
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
