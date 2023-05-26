//
//  DependencyProvider.swift
//  KISS Views
//

import UIKit

/// An abstraction describing a dependency provider.
protocol DependencyProvider {
    var favouriteAssetsManager: FavouriteAssetsManager { get }
    var assetsProvider: AssetsProvider { get }
    var assetsRatesProvider: AssetsRatesProvider { get }
    var historicalAssetRatesProvider: HistoricalAssetRatesProvider { get }
    var router: UIKitNavigationRouter { get }
}

/// A default implementation of DependencyProvider.
struct DefaultDependencyProvider: DependencyProvider {
    let favouriteAssetsManager: FavouriteAssetsManager
    let assetsRatesProvider: AssetsRatesProvider
    let assetsProvider: AssetsProvider
    let historicalAssetRatesProvider: HistoricalAssetRatesProvider
    let router: UIKitNavigationRouter

    /// A default initializer for DefaultDependencyProvider.
    init(rootViewController: UINavigationController) {
        let favouriteAssetsManager = DefaultFavouriteAssetsManager()
        let networkModule = NetworkingFactory.makeNetworkingModule()
        let baseAssetManager = DefaultBaseAssetManager()

        router = DefaultUIKitNavigationRouter(navigator: rootViewController)
        assetsRatesProvider = DefaultAssetsRatesProvider(
            favouriteAssetsProvider: favouriteAssetsManager,
            networkModule: networkModule,
            baseAssetProvider: baseAssetManager
        )
        historicalAssetRatesProvider = DefaultHistoricalAssetRatesProvider(
            networkModule: networkModule,
            baseAssetProvider: baseAssetManager
        )
        assetsProvider = DefaultAssetsProvider(networkModule: networkModule)

        self.favouriteAssetsManager = favouriteAssetsManager
    }
}
