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
    private let alertPresenter: AlertPresenter
    private var favouriteAssets: [Asset]
    private var cancellables = Set<AnyCancellable>()

    /// A default initializer for DefaultSwiftUIRouterHomeViewModel.
    ///
    /// - Parameter favouriteAssetsManager: a favourite assets manager.
    /// - Parameter assetsRatesProvider: an assets rates provider.
    /// - Parameter router: a navigation router.
    /// - Parameter alertPresenter: an alert presenter.
    init(
        favouriteAssetsManager: FavouriteAssetsManager,
        assetsRatesProvider: AssetsRatesProvider,
        router: UIKitNavigationRouter,
        alertPresenter: AlertPresenter
    ) {
        self.favouriteAssetsManager = favouriteAssetsManager
        self.assetsRatesProvider = assetsRatesProvider
        self.router = router
        self.alertPresenter = alertPresenter
        let favouriteAssets = favouriteAssetsManager.retrieveFavouriteAssets()
        viewState = UIKitRouterAssetsListViewModel.composeViewState(favouriteAssets: favouriteAssets)
        self.favouriteAssets = favouriteAssets
        subscribeToFavouriteAssetsUpdates()
        getAssetRates()
    }

    /// - SeeAlso: AssetsListViewModel.getAssetRates()
    func onAssetSelected(id: String) {
        router.show(route: MainAppRoute.assetDetails(assetId: id), withData: nil)
    }

    /// - SeeAlso: AssetsListViewModel.onAssetSelectedToBeEdited(id:)
    func onAssetSelectedToBeEdited(id: String) {
        router.show(route: MainAppRoute.editAsset(assetId: id), withData: nil)
    }

    /// - SeeAlso: AssetsListViewModel.onAddNewAssetTapped()
    func onAddNewAssetTapped() {
        router.show(route: MainAppRoute.addAsset, withData: nil)
    }

    /// - SeeAlso: AssetsListViewModel.onAssetSelectedForRemoval(id:)
    func onAssetSelectedForRemoval(id: String) {
        guard let asset = favouriteAssets.filter({
            $0.id == id
        })
        .first,
        let viewController = router.currentFlow?.navigator.navigationStack
        else {
            return
        }

        showAssetDeletionAlert(viewController: viewController, asset: asset, id: id)
    }

    /// - SeeAlso: AssetsListViewModel.addAssetToFavourites(id:)
    func removeAssetFromFavourites(id: String) {
        favouriteAssets.removeAll { $0.id == id }
        favouriteAssetsManager.store(favouriteAssets: favouriteAssets)
        getAssetRates()
        showAssetRemovedAlert(id: id)
    }

    /// - SeeAlso: AssetsListViewModel.onRefreshRequested()
    func onRefreshRequested() {
        getAssetRates()
    }

    /// - SeeAlso: AssetsListViewModel.onAppInfoTapped()
    func onAppInfoTapped() {
        router.show(route: MainAppRoute.appInfo, withData: nil)
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

    func showAssetDeletionAlert(viewController: UINavigationController, asset: Asset, id: String) {
        alertPresenter.showAcceptanceAlert(
            on: viewController,
            title: "Confirmation required?",
            message: "Would you like to remove \(asset.name) from favourites?"
        ) { [weak self] answer in
            if answer == .yes {
                self?.removeAssetFromFavourites(id: id)
            }
        }
    }

    func showAssetRemovedAlert(id: String) {
        guard let viewController = router.currentFlow?.navigator.navigationStack else {
            return
        }

        alertPresenter.showInfoAlert(
            on: viewController,
            title: "Asset \(id) has been removed from favourites.",
            message: nil,
            completion: nil
        )
    }
}

extension UIKitRouterAssetsListViewModel {
    var viewStatePublished: Published<AssetsListViewState> { _viewState }
    var viewStatePublisher: Published<AssetsListViewState>.Publisher { $viewState }
}
