//
//  FavouriteAssetsManager.swift
//  KISS Views
//

import Combine
import Foundation

/// An abstraction providing list of favourite assets.
protocol FavouriteAssetsProvider: AnyObject {

    /// Provides list of favourite assets.
    func retrieveFavouriteAssets() -> [Asset]

    var didChange: AnyPublisher<Void, Never> { get }
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
    var didChange: AnyPublisher<Void, Never> {
        didChangeSubject.eraseToAnyPublisher()
    }

    private let localStorage: LocalStorage
    private let didChangeSubject = PassthroughSubject<Void, Never>()

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
        didChangeSubject.send(())
    }

    /// - SeeAlso: FavouriteAssetsManager.clear()
    func clear() {
        localStorage.removeObject(forKey: Const.Key)
        didChangeSubject.send(())
    }
}

private extension DefaultFavouriteAssetsManager {

    enum Const {
        static let Key = "favouriteAssets"
    }
}
