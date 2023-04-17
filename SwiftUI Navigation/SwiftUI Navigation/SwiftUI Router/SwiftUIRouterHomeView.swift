//
//  SwiftUIRouterHomeView.swift
//  KISS Views
//

import SwiftUI

struct SwiftUIRouterHomeView<ViewModel: SwiftUIRouterHomeViewModel, Router: NavigationRouter>: View {
    @ObservedObject var viewModel: ViewModel
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
            AssetsListView(
                viewModel: DefaultAssetsListViewModel(
                    favouriteAssetsManager: viewModel.favouriteAssetsManager,
                    assetsRatesProvider: DefaultAssetsRatesProvider(favouriteAssetsProvider: viewModel.favouriteAssetsManager),
                    router: router
                )
            )
            .toolbar {
                ToolbarItem {
                    Button {
                        restoreNavState()
                    } label: {
                        Image(systemName: "icloud.and.arrow.down.fill")
                    }
                    .disabled(!viewModel.canRestoreNavState)
                }
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
                    makeEditAssetView(id: id)
                case let .assetDetails(id):
                    makeAssetDetailsView(id: id)
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
                    case let .deleteAsset(assetId, _):
                        viewModel.removeAssetFromFavourites(id: assetId)
                    }
                }
            )
        }
    }
}

private extension SwiftUIRouterHomeView {

    func restoreNavState() {
        guard let asset = viewModel.getRandomFavouriteAsset() else {
            return
        }

        router.set(navigationStack: [
            .makeScreen(named: .assetDetails(asset.id)),
            .makeScreen(named: .editAsset(asset.id))
        ])
    }

    func makeAddAssetView() -> some View {
        let viewModel = DefaultAddAssetViewModel(
            assetsProvider: DefaultAssetsProvider(),
            favouriteAssetsManager: viewModel.favouriteAssetsManager,
            router: router
        )
        return AddAssetView(viewModel: viewModel)
    }

    func makeEditAssetView(id: String) -> some View {
        let viewModel = DefaultEditAssetViewModel(
            assetId: id,
            favouriteAssetsManager: viewModel.favouriteAssetsManager,
            router: router
        )
        return EditAssetView(viewModel: viewModel)
    }

    func makeAssetDetailsView(id: String) -> some View {
        let viewModel = DefaultAssetDetailsViewModel(
            assetId: id,
            favouriteAssetsManager: viewModel.favouriteAssetsManager,
            router: router
        )
        return AssetDetailsView(viewModel: viewModel)
    }
}

struct SwiftUIRouterHomeView_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUIRouterHomeView(
            viewModel: PreviewSwiftUIRouterHomeViewModel(),
            router: PreviewNavigationRouter()
        )
    }
}
