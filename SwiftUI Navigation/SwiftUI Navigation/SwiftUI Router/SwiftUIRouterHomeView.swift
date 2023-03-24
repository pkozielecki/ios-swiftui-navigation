//
//  SwiftUIRouterHomeView.swift
//  KISS Views
//

import SwiftUI

struct SwiftUIRouterHomeView<Router: NavigationRouter>: View {
    @ObservedObject var router: Router

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack(
            path: .init(
                get: {
                    router.navigationStack
                },
                set: { stack in
                    router.set(navigationStack: stack)
                })
        ) {
            AssetsListView(router: router)
                .navigationTitle("Assets list")
                .toolbar {
                    ToolbarItem {
                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: "x.circle")
                        }
                    }
                }
        }
        .navigationDestination(for: NavigationRoute.self) { route in
            //  Handling app screens, pushed to the navigation stack:
            switch route.screen {
            case .editAsset:
                EditAssetView()
            }
        }
    }
}

struct SwiftUIRouterHome_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUIRouterHomeView(
            router: PreviewNavigationRouter()
        )
    }
}
