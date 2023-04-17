//
//  PreviewFixtures.swift
//  KISS Views
//

import Combine
import Foundation
import SwiftUI

final class PreviewNavigationRouter: NavigationRouter {
    @Published var navigationRoute: NavigationRoute?
    var navigationPathPublished: Published<NavigationRoute?> { _navigationRoute }
    var navigationPathPublisher: Published<NavigationRoute?>.Publisher { $navigationRoute }
    private(set) var navigationStack: [NavigationRoute] = []

    @Published var presentedPopup: PopupRoute?
    var presentedPopupPublished: Published<PopupRoute?> { _presentedPopup }
    var presentedPopupPublisher: Published<PopupRoute?>.Publisher { $presentedPopup }

    @Published var presentedAlert: AlertRoute?
    var presentedAlertPublished: Published<AlertRoute?> { _presentedAlert }
    var presentedAlertPublisher: Published<AlertRoute?>.Publisher { $presentedAlert }

    func set(navigationStack: [NavigationRoute]) {}

    func present(popup: PopupRoute.Popup) {}
    func dismiss() {}

    func push(screen: NavigationRoute.Screen) {}
    func pop() {}
    func popAll() {}

    func show(alert: AlertRoute.Alert) {}
    func hideCurrentAlert() {}
}

final class PreviewAddAssetViewModel: AddAssetViewModel {
    @Published var viewState: AddAssetViewState
    var viewStatePublished: Published<AddAssetViewState> { _viewState }
    var viewStatePublisher: Published<AddAssetViewState>.Publisher { $viewState }
    @Published var searchPhrase: String = ""
    var searchPhrasePublished: Published<String> { _searchPhrase }
    var searchPhrasePublisher: Published<String>.Publisher { $searchPhrase }
    var selectedAssetsIds: [String] = []

    init(state: AddAssetViewState) {
        viewState = state
    }

    func onAssetTapped(id: String) {}
    func onAssetsSelectionConfirmed() {}
}

final class PreviewAssetsListViewModel: AssetsListViewModel {
    @Published var viewState: AssetsListViewState
    var viewStatePublished: Published<AssetsListViewState> { _viewState }
    var viewStatePublisher: Published<AssetsListViewState>.Publisher { $viewState }

    init(state: AssetsListViewState) {
        viewState = state
    }

    func onAddNewAssetTapped() {}
    func onAssetSelected(id: String) {}
    func removeAssetFromFavourites(id: String) {}
    func onAssetSelectedToBeEdited(id: String) {}
    func onAssetSelectedForRemoval(id: String) {}
    func onRefreshRequested() {}
}

final class PreviewSwiftUIRouterHomeViewModel: SwiftUIRouterHomeViewModel {
    let favouriteAssetsManager: FavouriteAssetsManager = DefaultFavouriteAssetsManager()
    var canRestoreNavState: Bool = true

    func removeAssetFromFavourites(id: String) {}
    func editAssets(id: String) {}
    func getRandomFavouriteAsset() -> Asset? { nil }
}

final class PreviewAssetDetailsViewModel: AssetDetailsViewModel {
    @Published var viewState: AssetDetailsViewState
    var viewStatePublished: Published<AssetDetailsViewState> { _viewState }
    var viewStatePublisher: Published<AssetDetailsViewState>.Publisher { $viewState }
    var assetData: AssetDetailsViewData = .init(id: "BTC", name: "Bitcoin")

    init(state: AssetDetailsViewState) {
        viewState = state
    }

    func edit(asset assetID: String) {}
    func reloadChart(scope: ChartView.Scope) {}
}

final class PreviewEditAssetViewModel: EditAssetViewModel {
    @Published var viewState: EditAssetViewState
    var viewStatePublished: Published<EditAssetViewState> { _viewState }
    var viewStatePublisher: Published<EditAssetViewState>.Publisher { $viewState }
    var assetId: String = ""

    init(state: EditAssetViewState) {
        viewState = state
    }

    func popToRoot() {}
    func saveChanges(assetData: EditAssetViewData) {}
}
