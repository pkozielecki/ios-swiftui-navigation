//
//  FakeFavouriteAssetsManager.swift
//  KISS Views
//

import Combine
import Foundation

@testable import SwiftUI_Navigation

final class FakeFavouriteAssetsManager: FavouriteAssetsManager {
    var simulatedFavouriteAssets: [Asset]?
    var didChangeSubject = PassthroughSubject<Void, Never>()
    var didChange: AnyPublisher<Void, Never> {
        didChangeSubject.eraseToAnyPublisher()
    }

    func retrieveFavouriteAssets() -> [Asset] {
        simulatedFavouriteAssets ?? []
    }

    func store(favouriteAssets assets: [Asset]) {
        simulatedFavouriteAssets = assets
    }

    func clear() {
        simulatedFavouriteAssets = []
    }
}
