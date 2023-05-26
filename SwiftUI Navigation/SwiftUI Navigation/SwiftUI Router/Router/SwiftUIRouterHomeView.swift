//
//  SwiftUIRouterHomeView.swift
//  KISS Views
//

import SwiftUI

struct SwiftUIRouterHomeView<ViewModel: SwiftUIRouterHomeViewModel, Router: SwiftUINavigationRouter>: View {
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
                viewModel: SwiftUIRouterAssetsListViewModel(
                    favouriteAssetsManager: viewModel.favouriteAssetsManager,
                    assetsRatesProvider: DefaultAssetsRatesProvider(favouriteAssetsProvider: viewModel.favouriteAssetsManager),
                    router: router
                )
            )
            .toolbar {
                ToolbarItem {
                    Button {
                        showEmbeddedHomeView()
                    } label: {
                        Image(systemName: "character.duployan")
                    }
                }
                ToolbarItem {
                    Button {
                        showPopupHomeView()
                    } label: {
                        Image(systemName: "note")
                    }
                }
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
                case .embeddedHomeView:
                    makeEmbeddableHomeView()
                }
            }
            .sheet(item: $router.presentedPopup) { _ in
                if let $popup = Binding($router.presentedPopup) {
                    //  Handling app popups, presented as sheets:
                    switch $popup.wrappedValue.popup {
                    case .appInfo:
                        Text("SwiftUI Navigation v 0.1")
                    case .addAsset:
                        makeAddAssetView()
                    case .homeView:
                        makePopupHomeView()
                    }
                }
            }
            .alert(
                presenting: $router.presentedAlert,
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

    func showEmbeddedHomeView() {
        router.push(screen: .embeddedHomeView)
    }

    func showPopupHomeView() {
        router.present(popup: .homeView)
    }

    func makeAddAssetView() -> some View {
        let viewModel = SwiftUIRouterAddAssetViewModel(
            assetsProvider: DefaultAssetsProvider(),
            favouriteAssetsManager: viewModel.favouriteAssetsManager,
            router: router
        )
        return AddAssetView(viewModel: viewModel)
    }

    func makeEditAssetView(id: String) -> some View {
        let viewModel = SwiftUIRouterEditAssetViewModel(
            assetId: id,
            favouriteAssetsManager: viewModel.favouriteAssetsManager,
            router: router
        )
        return EditAssetView(viewModel: viewModel)
    }

    func makeAssetDetailsView(id: String) -> some View {
        let viewModel = SwiftUIRouterAssetDetailsViewModel(
            assetId: id,
            favouriteAssetsManager: viewModel.favouriteAssetsManager,
            historicalAssetRatesProvider: DefaultHistoricalAssetRatesProvider(),
            router: router
        )
        return AssetDetailsView(viewModel: viewModel)
    }

    func makeEmbeddableHomeView() -> some View {
        //  Discussion: Navigation Stack does not work well with another Navigation Stacks embedded within it...
        //  ... therefore we need reuse the router we have connected to the original Home View...
        //  ... this way, all the navigation requests will be handled by the original Nav Stack, and not the "new" one.
        //  TLDR: I think this has to be changed sooner or later as embedded navigation stack is a must-have feature!
        SwiftUIRouterHomeView<ViewModel, Router>(viewModel: viewModel, router: router)
    }

    func makePopupHomeView() -> some View {
        //  Discussion: Apparently, a Navigation Stack displayed on a sheet does not interfere with the "main" Nav Stack...
        //  ... therefore we can create a new router to handle that Nav Stack:
        let router = DefaultSwiftUINavigationRouter()
        return SwiftUIRouterHomeView<DefaultSwiftUIRouterHomeViewModel, DefaultSwiftUINavigationRouter>(
            viewModel: DefaultSwiftUIRouterHomeViewModel(
                favouriteAssetsManager: viewModel.favouriteAssetsManager,
                router: router
            ),
            router: router
        )
    }
}

struct SwiftUIRouterHomeView_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUIRouterHomeView(
            viewModel: PreviewSwiftUIRouterHomeViewModel(),
            router: PreviewSwiftUINavigationRouter()
        )
    }
}
