//
//  AssetsListViewModel.swift
//  KISS Views
//

import Combine
import Foundation

/// An enumeration describing Add Asset View state.
enum AssetsListViewState {
    case noFavouriteAssets
    case loading([FavouriteAssetCellView.Data])
    case loaded([FavouriteAssetCellView.Data], String)
}

/// An abstraction describing a View Model for .
protocol AssetsListViewModel: ObservableObject {
    /// A view state.
    var viewState: AssetsListViewState { get }
    var viewStatePublished: Published<AssetsListViewState> { get }
    var viewStatePublisher: Published<AssetsListViewState>.Publisher { get }

    /// Triggered on manual refresh requested.
    func onRefreshRequested()

    /// Triggerred on tapping Add Asset button.
    func onAddNewAssetTapped()

    /// Triggered on selecting an asset cell.
    ///
    /// - Parameter id: a selected asset id.
    func onAssetSelected(id: String)

    /// Triggered when user confirmed removal of an asset
    ///
    /// - Parameter id: an asset id.
    func removeAssetFromFavourites(id: String)

    /// Triggered on selecting an asset to be edited.
    ///
    /// - Parameter id: a selected asset id.
    func onAssetSelectedToBeEdited(id: String)

    /// Triggered on selecting an asset for removal.
    ///
    /// - Parameter id: a selected asset id.
    func onAssetSelectedForRemoval(id: String)
}

final class DefaultAssetsListViewModel: AssetsListViewModel {
    @Published var viewState: AssetsListViewState

    private let router: any NavigationRouter
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
        router: any NavigationRouter
    ) {
        self.favouriteAssetsManager = favouriteAssetsManager
        self.assetsRatesProvider = assetsRatesProvider
        self.router = router
        let favouriteAssets = favouriteAssetsManager.retrieveFavouriteAssets()
        viewState = DefaultAssetsListViewModel.composeViewState(favouriteAssets: favouriteAssets)
        self.favouriteAssets = favouriteAssets
        subscribeToFavouriteAssetsUpdates()
        getAssetRates()
    }

    func onAssetSelected(id: String) {
        router.push(screen: .assetDetails(id))
    }

    func onAssetSelectedToBeEdited(id: String) {
        router.push(screen: .editAsset(id))
    }

    func onAddNewAssetTapped() {
        router.present(popup: .addAsset)
    }

    func onAssetSelectedForRemoval(id: String) {
        guard let asset = favouriteAssets.filter({ $0.id == id }).first else {
            return
        }

        router.show(alert: .deleteAsset(assetId: asset.id, assetName: asset.name))
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

private extension DefaultAssetsListViewModel {

    static func composeViewState(favouriteAssets: [Asset]) -> AssetsListViewState {
        favouriteAssets.isEmpty ? .noFavouriteAssets : .loading(favouriteAssets.map { FavouriteAssetCellView.Data(asset: $0) })
    }

    func refreshViewState() {
        favouriteAssets = favouriteAssetsManager.retrieveFavouriteAssets()
        viewState = DefaultAssetsListViewModel.composeViewState(favouriteAssets: favouriteAssets)
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

extension FavouriteAssetCellView.Data {
    init(asset: Asset) {
        self.init(id: asset.id, title: asset.name, color: asset.color, value: "...")
    }
}

extension DefaultAssetsListViewModel {
    var viewStatePublished: Published<AssetsListViewState> { _viewState }
    var viewStatePublisher: Published<AssetsListViewState>.Publisher { $viewState }
}
