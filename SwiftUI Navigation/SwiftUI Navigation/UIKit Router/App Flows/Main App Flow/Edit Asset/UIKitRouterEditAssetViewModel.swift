//
//  UIKitRouterEditAssetViewModel.swift
//  KISS Views
//

import Combine
import SwiftUI

/// A default EditAssetViewModel implementation.
final class UIKitRouterEditAssetViewModel: EditAssetViewModel {
    @Published var viewState: EditAssetViewState

    private let router: UIKitNavigationRouter
    private let favouriteAssetsManager: FavouriteAssetsManager

    /// A default initializer for EditAssetViewModel.
    ///
    /// - Parameter assetId: an asset id.
    /// - Parameter favouriteAssetsManager: a favourite assets manager.
    /// - Parameter router: a navigation router.
    init(
        assetId: String,
        favouriteAssetsManager: FavouriteAssetsManager,
        router: UIKitNavigationRouter
    ) {
        self.favouriteAssetsManager = favouriteAssetsManager
        self.router = router
        viewState = UIKitRouterEditAssetViewModel.calculateViewState(
            favouriteAssetsManager: favouriteAssetsManager,
            assetId: assetId
        )
    }

    /// - SeeAlso: EditAssetViewModel.saveChanges(assetData:)
    func saveChanges(assetData: EditAssetViewData) {
        let asset = Asset(id: assetData.id, name: assetData.name, colorCode: assetData.color.toHex())
        var assets = favouriteAssetsManager.retrieveFavouriteAssets()
        assets.removeAll { $0.id == assetData.id }
        assets.insert(asset, at: assetData.position.currentPosition - 1)
        favouriteAssetsManager.store(favouriteAssets: assets)
        router.navigateBack(animated: true)
    }
}

private extension UIKitRouterEditAssetViewModel {

    static func calculateViewState(
        favouriteAssetsManager: FavouriteAssetsManager,
        assetId: String
    ) -> EditAssetViewState {
        let assets = favouriteAssetsManager.retrieveFavouriteAssets()
        guard let asset = assets.filter({ $0.id == assetId }).first else {
            return .assetNotFound
        }

        let currentPosition = assets.firstIndex(of: asset) ?? 0
        return .editAsset(
            EditAssetViewData(asset: asset, position: currentPosition, totalAssetCount: assets.count)
        )
    }
}

extension UIKitRouterEditAssetViewModel {
    var viewStatePublished: Published<EditAssetViewState> { _viewState }
    var viewStatePublisher: Published<EditAssetViewState>.Publisher { $viewState }
}
