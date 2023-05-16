//
//  UIKitRouterAssetsListViewModel.swift
//  KISS Views
//

import Combine
import Foundation
import UIKit

/// An implementation of AssetsListViewModel; To be used in UIKit Router navigation.
final class UIKitRouterAssetsListViewModel: AssetsListViewModel {
    @Published var viewState: AssetsListViewState

    private let favouriteAssetsManager: FavouriteAssetsManager
    private let assetsRatesProvider: AssetsRatesProvider
    private let router: UIKitNavigationRouter
    private var favouriteAssets: [Asset]
    private var cancellables = Set<AnyCancellable>()

    /// A default initializer for DefaultSwiftUIRouterHomeViewModel.
    ///
    /// - Parameter favouriteAssetsManager: a favourite assets manager.
    /// - Parameter assetsRatesProvider: an assets rates provider.
    /// - Parameter router: a navigation router.
    init(
        favouriteAssetsManager: FavouriteAssetsManager,
        assetsRatesProvider: AssetsRatesProvider,
        router: UIKitNavigationRouter
    ) {
        self.favouriteAssetsManager = favouriteAssetsManager
        self.assetsRatesProvider = assetsRatesProvider
        self.router = router
        let favouriteAssets = favouriteAssetsManager.retrieveFavouriteAssets()
        viewState = UIKitRouterAssetsListViewModel.composeViewState(favouriteAssets: favouriteAssets)
        self.favouriteAssets = favouriteAssets
        subscribeToFavouriteAssetsUpdates()
        getAssetRates()
    }

    func onAssetSelected(id: String) {
        router.show(route: MainAppRoute.assetDetails(assetId: id), withData: nil)
    }

    func onAssetSelectedToBeEdited(id: String) {
        print("Edit asset tapped")
    }

    func onAddNewAssetTapped() {
        print("Add new asset tapped")
    }

    func onAssetSelectedForRemoval(id: String) {
        guard let asset = favouriteAssets.filter({ $0.id == id }).first else {
            return
        }

        print(asset)
    }

    func removeAssetFromFavourites(id: String) {
        favouriteAssets.removeAll { $0.id == id }
        favouriteAssetsManager.store(favouriteAssets: favouriteAssets)
        getAssetRates()
    }

    func onRefreshRequested() {
        getAssetRates()
    }
}

private extension UIKitRouterAssetsListViewModel {

    static func composeViewState(favouriteAssets: [Asset]) -> AssetsListViewState {
        favouriteAssets.isEmpty ? .noFavouriteAssets : .loading(favouriteAssets.map { FavouriteAssetCellView.Data(asset: $0) })
    }

    func refreshViewState() {
        favouriteAssets = favouriteAssetsManager.retrieveFavouriteAssets()
        viewState = UIKitRouterAssetsListViewModel.composeViewState(favouriteAssets: favouriteAssets)
    }

    func subscribeToFavouriteAssetsUpdates() {
        favouriteAssetsManager
            .didChange
            .sink(receiveValue: { [weak self] _ in
                self?.refreshViewState()
                self?.getAssetRates()
            })
            .store(in: &cancellables)
    }

    func getAssetRates() {
        Task { @MainActor [weak self] in
            guard let self else { return }

            let dateFormatter = DateFormatter.fullDateFormatter
            let rates = await self.assetsRatesProvider.getAssetRates()
            guard !rates.isEmpty else { return }

            let lastUpdated = rates.first?.price?.date ?? Date()
            let lastUpdatedString = dateFormatter.string(from: lastUpdated)
            let data = favouriteAssets.map { favouriteAsset -> FavouriteAssetCellView.Data in
                let rate = rates.first { $0.id == favouriteAsset.id }
                let formattedValue = rate?.price?.formattedPrice
                return FavouriteAssetCellView.Data(asset: favouriteAsset, formattedValue: formattedValue)
            }
            self.viewState = .loaded(data, lastUpdatedString)
        }
    }
}

extension UIKitRouterAssetsListViewModel {
    var viewStatePublished: Published<AssetsListViewState> { _viewState }
    var viewStatePublisher: Published<AssetsListViewState>.Publisher { $viewState }
}
