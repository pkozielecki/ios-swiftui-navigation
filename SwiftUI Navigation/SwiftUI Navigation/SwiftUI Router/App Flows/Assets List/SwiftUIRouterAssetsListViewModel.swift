//
//  SwiftUIRouterAssetsListViewModel.swift
//  KISS Views
//

import Combine
import UIKit

final class SwiftUIRouterAssetsListViewModel: AssetsListViewModel {
    @Published var viewState: AssetsListViewState

    private let router: any SwiftUINavigationRouter
    private let favouriteAssetsManager: FavouriteAssetsManager
    private let assetsRatesProvider: AssetsRatesProvider
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
        router: any SwiftUINavigationRouter
    ) {
        self.favouriteAssetsManager = favouriteAssetsManager
        self.assetsRatesProvider = assetsRatesProvider
        self.router = router
        let favouriteAssets = favouriteAssetsManager.retrieveFavouriteAssets()
        viewState = SwiftUIRouterAssetsListViewModel.composeViewState(favouriteAssets: favouriteAssets)
        self.favouriteAssets = favouriteAssets
        subscribeToFavouriteAssetsUpdates()
        getAssetRates()
    }

    /// - SeeAlso: AssetsListViewModel.onAssetSelected(id:)
    func onAssetSelected(id: String) {
        router.push(screen: .assetDetails(id))
    }

    /// - SeeAlso: AssetsListViewModel.onAssetSelectedToBeEdited(id:)
    func onAssetSelectedToBeEdited(id: String) {
        router.push(screen: .editAsset(id))
    }

    /// - SeeAlso: AssetsListViewModel.onAddNewAssetTapped()
    func onAddNewAssetTapped() {
        router.present(popup: .addAsset)
    }

    /// - SeeAlso: AssetsListViewModel.onAppInfoTapped()
    func onAppInfoTapped() {
        router.present(popup: .appInfo)
    }

    /// - SeeAlso: AssetsListViewModel.onAssetSelectedForRemoval(id:)
    func onAssetSelectedForRemoval(id: String) {
        guard let asset = favouriteAssets.filter({ $0.id == id }).first else {
            return
        }

        router.show(alert: .deleteAsset(assetId: asset.id, assetName: asset.name))
    }

    /// - SeeAlso: AssetsListViewModel.onAssetSelectedForFavouriteToggle(id:)
    func removeAssetFromFavourites(id: String) {
        favouriteAssets.removeAll { $0.id == id }
        favouriteAssetsManager.store(favouriteAssets: favouriteAssets)
        getAssetRates()
    }

    /// - SeeAlso: AssetsListViewModel.onRefreshRequested()
    func onRefreshRequested() {
        getAssetRates()
    }
}

private extension SwiftUIRouterAssetsListViewModel {

    static func composeViewState(favouriteAssets: [Asset]) -> AssetsListViewState {
        favouriteAssets.isEmpty ? .noFavouriteAssets : .loading(favouriteAssets.map { FavouriteAssetCellView.Data(asset: $0) })
    }

    func refreshViewState() {
        favouriteAssets = favouriteAssetsManager.retrieveFavouriteAssets()
        viewState = SwiftUIRouterAssetsListViewModel.composeViewState(favouriteAssets: favouriteAssets)
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

extension SwiftUIRouterAssetsListViewModel {
    var viewStatePublished: Published<AssetsListViewState> { _viewState }
    var viewStatePublisher: Published<AssetsListViewState>.Publisher { $viewState }
}
