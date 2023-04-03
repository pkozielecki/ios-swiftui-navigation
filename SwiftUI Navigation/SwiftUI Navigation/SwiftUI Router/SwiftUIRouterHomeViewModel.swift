//
//  SwiftUIRouterHomeViewModel.swift
//  KISS Views
//

import Combine
import Foundation

/// An abstraction describing a View Model for .
protocol SwiftUIRouterHomeViewModel: ObservableObject {
    var favouriteAssetsManager: FavouriteAssetsManager { get }
    func removeAssetFromFavourites(id: String)

    func editAssets(id: String)
}

final class DefaultSwiftUIRouterHomeViewModel: SwiftUIRouterHomeViewModel {
    let favouriteAssetsManager: FavouriteAssetsManager

    private let router: any NavigationRouter

    /// A default initializer for DefaultSwiftUIRouterHomeViewModel.
    ///
    /// - Parameter favouriteAssetsManager: a favourite assets manager.
    /// - Parameter router: a navigation router.
    init(
        favouriteAssetsManager: FavouriteAssetsManager,
        router: any NavigationRouter
    ) {
        self.favouriteAssetsManager = favouriteAssetsManager
        self.router = router
    }

    func removeAssetFromFavourites(id: String) {
        var assets = favouriteAssetsManager.retrieveFavouriteAssets()
        assets.removeAll { $0.id == id }
        favouriteAssetsManager.store(favouriteAssets: assets)
        objectWillChange.send()
    }

    func editAssets(id: String) {
        router.push(screen: .editAsset(id))
    }
}
