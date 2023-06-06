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
    var alertPresenter: AlertPresenter { get }
    var rootAppNavigator: Navigator { get }
}

/// A default implementation of DependencyProvider.
struct DefaultDependencyProvider: DependencyProvider {
    let favouriteAssetsManager: FavouriteAssetsManager
    let assetsRatesProvider: AssetsRatesProvider
    let assetsProvider: AssetsProvider
    let historicalAssetRatesProvider: HistoricalAssetRatesProvider
    let router: UIKitNavigationRouter
    let alertPresenter: AlertPresenter
    let rootAppNavigator: Navigator

    /// A default initializer for DefaultDependencyProvider.
    init(rootAppNavigator: Navigator) {
        let favouriteAssetsManager = DefaultFavouriteAssetsManager()
        let networkModule = NetworkingFactory.makeNetworkingModule()
        let baseAssetManager = DefaultBaseAssetManager()

        router = DefaultUIKitNavigationRouter()
        alertPresenter = DefaultAlertPresenter()
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
        self.rootAppNavigator = rootAppNavigator
    }
}
