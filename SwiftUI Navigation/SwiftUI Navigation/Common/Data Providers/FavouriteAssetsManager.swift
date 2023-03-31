//
//  FavouriteAssetsManager.swift
//  KISS Views
//

import Foundation

/// An abstraction providing list of favourite assets.
protocol FavouriteAssetsProvider: AnyObject {

    /// Provides list of favourite assets.
    func retrieveFavouriteAssets() -> [Asset]
}

/// An abstraction allowing to store favourite assets.
protocol FavouriteAssetsStorage: AnyObject {

    /// Stores assets as favourites.
    ///
    /// - Parameter assets: a list of assets.
    func store(favouriteAssets assets: [Asset])

    /// Clears the list of favourite assets.
    func clear()
}

/// An abstraction managing favourite assets.
protocol FavouriteAssetsManager: FavouriteAssetsProvider, FavouriteAssetsStorage {}

/// A default FavouriteAssetsManager implementation.
final class DefaultFavouriteAssetsManager: FavouriteAssetsManager {
    private let localStorage: LocalStorage

    /// A DefaultFavouriteAssetsManager initializer.
    ///
    /// - Parameter localStorage: a local storage.
    init(localStorage: LocalStorage = UserDefaults.standard) {
        self.localStorage = localStorage
    }

    /// - SeeAlso: FavouriteAssetsManager.retrieveFavouriteAssets()
    func retrieveFavouriteAssets() -> [Asset] {
        let storedObject = localStorage.data(forKey: Const.Key)
        return storedObject?.decoded(into: [Asset].self) ?? []
    }

    /// - SeeAlso: FavouriteAssetsManager.store(assets:)
    func store(favouriteAssets assets: [Asset]) {
        localStorage.set(assets.data, forKey: Const.Key)
    }

    /// - SeeAlso: FavouriteAssetsManager.clear()
    func clear() {
        localStorage.removeObject(forKey: Const.Key)
    }
}

private extension DefaultFavouriteAssetsManager {

    enum Const {
        static let Key = "favouriteAssets"
    }
}
