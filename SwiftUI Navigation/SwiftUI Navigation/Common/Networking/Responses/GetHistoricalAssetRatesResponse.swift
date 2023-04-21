//
//  GetHistoricalAssetRatesResponse.swift
//  KISS Views
//

import Foundation

/// A response structure for GetHistoricalAssetRates request.
struct GetHistoricalAssetRatesResponse: Codable {
    let rates: [String: [String: Double]]
}

extension GetHistoricalAssetRatesResponse {

    /// A convenience function parsing the response into app data model.
    ///
    /// - Parameter assetID: an ID of an asset to get rates for.
    /// - Returns: a collection of asset historical rates.
    func composeHistoricalAssetRates(for assetID: String) -> [AssetHistoricalRate] {
        var rates = [AssetHistoricalRate]()
        for (date, assetsValues) in self.rates {
            if let assetValue = assetsValues[assetID] {
                rates.append(AssetHistoricalRate(id: assetID, date: date, value: 1 / assetValue))
            }
        }
        return rates
    }
}
