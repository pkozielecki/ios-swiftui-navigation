//
//  FakeSwiftUIRouterHomeViewModel.swift
//  KISS Views
//

import Foundation

@testable import SwiftUI_Navigation

final class FakeSwiftUIRouterHomeViewModel: SwiftUIRouterHomeViewModel {
    var fakeFavouriteAssetsManager = FakeFavouriteAssetsManager()
    var favouriteAssetsManager: FavouriteAssetsManager {
        fakeFavouriteAssetsManager
    }

    var canRestoreNavState = true

    func removeAssetFromFavourites(id: String) {}

    func getRandomFavouriteAsset() -> Asset? {
        nil
    }

    func editAssets(id: String) {}
}
