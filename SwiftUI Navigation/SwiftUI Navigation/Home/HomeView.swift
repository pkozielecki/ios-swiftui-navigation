//
//  HomeView.swift
//  KISS Views
//

import SwiftUI

struct HomeView: View {
    @State private var isSwiftUINaviPresented = false
    @State private var isUIKitNaviPresented = false
    @State private var isViewStateNaviPresented = false

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
                    let router = DefaultNavigationRouter()
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
                    UIKitRouterHomeView {
                        isUIKitNaviPresented = false
                    }
                }

                Divider()
                Button("View State (drill-down) navigation") {
                    isViewStateNaviPresented.toggle()
                }
                .fullScreenCover(isPresented: $isViewStateNaviPresented) {
                    // TODO: show SwiftUI View state-based navi showcase
                    Button("Back") {
                        isViewStateNaviPresented = false
                    }
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
