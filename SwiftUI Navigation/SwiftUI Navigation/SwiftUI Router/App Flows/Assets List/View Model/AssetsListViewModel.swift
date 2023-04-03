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
    case loaded([FavouriteAssetCellView.Data])
}

/// An abstraction describing a View Model for .
protocol AssetsListViewModel: ObservableObject {
    /// A view state.
    var viewState: AssetsListViewState { get }
    var viewStatePublished: Published<AssetsListViewState> { get }
    var viewStatePublisher: Published<AssetsListViewState>.Publisher { get }

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
    private let favouriteAssetsManager: any FavouriteAssetsManager
    private var favouriteAssets: [Asset]
    private var cancellables = Set<AnyCancellable>()

    /// A default initializer for DefaultSwiftUIRouterHomeViewModel.
    ///
    /// - Parameter favouriteAssetsManager: a favourite assets manager.
    /// - Parameter router: a navigation router.
    init(
        favouriteAssetsManager: any FavouriteAssetsManager,
        router: any NavigationRouter
    ) {
        self.favouriteAssetsManager = favouriteAssetsManager
        self.router = router
        let favouriteAssets = favouriteAssetsManager.retrieveFavouriteAssets()
        viewState = DefaultAssetsListViewModel.composeViewState(favouriteAssets: favouriteAssets)
        self.favouriteAssets = favouriteAssets
        subscribeToFavouriteAssetsUpdates()
        // TODO: load assets performance data
    }

    func removeAssetFromFavourites(id: String) {
        favouriteAssets.removeAll { $0.id == id }
        favouriteAssetsManager.store(favouriteAssets: favouriteAssets)
        objectWillChange.send()
    }

    func onAssetSelected(id: String) {
        router.push(screen: .assetCharts(id))
    }

    func onAssetSelectedToBeEdited(id: String) {
        router.push(screen: .editAsset(id))
    }

    func onAddNewAssetTapped() {
        router.present(popup: .addAsset)
    }

    func onAssetSelectedForRemoval(id: String) {
        guard let asset = favouriteAssets.filter({
            $0.id == id
        })
        .first else {
            return
        }
        router.show(alert: .deleteAsset(assetId: asset.id, assetName: asset.name))
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
            })
            .store(in: &cancellables)
    }
}

extension FavouriteAssetCellView.Data {
    init(asset: Asset) {
        self.init(id: asset.id, title: asset.name, value: nil)
    }
}

extension DefaultAssetsListViewModel {
    var viewStatePublished: Published<AssetsListViewState> { _viewState }
    var viewStatePublisher: Published<AssetsListViewState>.Publisher { $viewState }
}
