//
//  FakeDependencyProvider.swift
//  KISS Views
//

import Foundation

@testable import SwiftUI_Navigation

final class FakeDependencyProvider: DependencyProvider {
    let fakeRootAppNavigator = FakeNavigator()
    let fakeFavouriteAssetsManager = FakeFavouriteAssetsManager()
    let fakeAssetsProvider = FakeAssetsProvider()
    let fakeUIKitNavigationRouter = FakeUIKitNavigationRouter()
    let fakeAssetsRatesProvider = FakeAssetsRatesProvider()
    let fakeHistoricalAssetRatesProvider = FakeHistoricalAssetRatesProvider()

    var rootAppNavigator: Navigator {
        fakeRootAppNavigator
    }

    var favouriteAssetsManager: FavouriteAssetsManager {
        fakeFavouriteAssetsManager
    }

    var assetsProvider: AssetsProvider {
        fakeAssetsProvider
    }

    var assetsRatesProvider: AssetsRatesProvider {
        fakeAssetsRatesProvider
    }

    var historicalAssetRatesProvider: HistoricalAssetRatesProvider {
        fakeHistoricalAssetRatesProvider
    }

    var router: UIKitNavigationRouter {
        fakeUIKitNavigationRouter
    }
}
