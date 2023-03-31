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
                .navigationDestination(for: NavigationRoute.self) { route in
                    //  Handling app screens, pushed to the navigation stack:
                    switch route.screen {
                    case let .editAsset(id):
                        Text("Editing asset: \(id)")
                    case let .assetCharts(id):
                        Text("Charts for asset: \(id)")
                    }
                }
                .sheet(item: $router.presentedPopup) { _ in
                    if let $popup = Binding($router.presentedPopup) {
                        //  Handling app popups, presented as sheets:
                        switch $popup.wrappedValue.popup {
                        case .addAsset:
                            makeAddAssetView()
                        }
                    }
                }
                .alert(
                    presenting: $router.presentedAlert,
                    confirmationActionTitle: "Delete",
                    confirmationActionCallback: { alertRoute in
                        //  Handling app alert confirmation action:
                        switch alertRoute.alert {
                        case let .deleteAsset(assetId, assetName):
                            print("asset \(assetId) \(assetName) removed")
                            // TODO: Remove an asset from favourites
                        }
                    }
                )
        }
    }
}

private extension SwiftUIRouterHomeView {

    func makeAddAssetView() -> some View {
        let viewModel = DefaultAddAssetViewModel(
            assetsProvider: DefaultAssetsProvider(),
            favouriteAssetsManager: DefaultFavouriteAssetsManager(),
            router: router
        )
        return AddAssetView(viewModel: viewModel)
    }
}

struct SwiftUIRouterHomeView_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUIRouterHomeView(
            router: PreviewNavigationRouter()
        )
    }
}
