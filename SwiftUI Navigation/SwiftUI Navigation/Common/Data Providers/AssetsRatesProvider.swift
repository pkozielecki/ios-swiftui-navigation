//
//  AssetsRatesProvider.swift
//  KISS Views
//

import ConcurrentNgNetworkModule
import Foundation
import NgNetworkModuleCore

/// An abstraction providing rates of exchange for favourite assets.
protocol AssetsRatesProvider: Actor {

    /// Retrieves exchange rates for assets compared to the exchange base.
    ///
    /// - Returns: a collection of asset performances.
    func getAssetRates() async -> [AssetPerformance]
}

/// A default AssetsRatesProvider implementation.
final actor DefaultAssetsRatesProvider: AssetsRatesProvider {
    private let favouriteAssetsProvider: FavouriteAssetsProvider
    private let networkModule: NetworkModule
    private let baseAssetProvider: BaseAssetProvider

    /// A default initializer for DefaultAssetsRatesProvider.
    ///
    /// - Parameter favouriteAssetsProvider: a favourite assets provider.
    /// - Parameter networkModule: a networking module.
    /// - Parameter baseAssetProvider: a base asset provider.
    init(
        favouriteAssetsProvider: FavouriteAssetsProvider,
        networkModule: NetworkModule = NetworkingFactory.makeNetworkingModule(),
        baseAssetProvider: BaseAssetProvider = DefaultBaseAssetManager()
    ) {
        self.favouriteAssetsProvider = favouriteAssetsProvider
        self.networkModule = networkModule
        self.baseAssetProvider = baseAssetProvider
    }

    /// - SeeAlso: AssetsRatesProvider.getAssetRates()
    func getAssetRates() async -> [AssetPerformance] {
        let baseAsset = baseAssetProvider.baseAsset
        let favouriteAssets = favouriteAssetsProvider.retrieveFavouriteAssets()
        let request = GetAssetsRatesRequest(assetIDs: favouriteAssets.map { $0.id }, base: baseAsset.id)
        do {
            let response = try await networkModule.performAndDecode(request: request, responseType: GetAssetsRatesResponse.self)
            return response.rates.map { key, value -> AssetPerformance in
                let date = Date(timeIntervalSince1970: response.timestamp)
                let price = AssetPrice(value: value, date: date, base: baseAsset)
                let assetName = favouriteAssets.filter { $0.id == key }.first?.name ?? ""
                return AssetPerformance(id: key, name: assetName, price: price)
            }
        } catch {
            return []
        }
    }
}
