//
//  GetHistoricalAssetRatesRequest.swift
//  KISS Views
//

import Foundation
import NgNetworkModuleCore

/// A request fetching selected asset historical rates.
struct GetHistoricalRatesRequest: NetworkRequest {
    let path = "v1/timeframe"
    let method = NetworkRequestType.get
    let requiresAuthenticationToken = true
    let parameters: [String: String]?

    /// A default GetHistoricalAssetRatesRequest initializer.
    ///
    /// - Parameters:
    ///   - assetID: an asset ID.
    ///   - base: an ID of an asset base to calculate rates for.
    ///   - startDate: a day to start the range.
    ///   - endDate: a day to finish the range.
    init(assetID: String, base: String, startDate: Date, endDate: Date) {
        let formatter = DateFormatter.dayMonthYearFormatter
        var parameters = [String: String]()
        parameters["base"] = base
        parameters["currencies"] = assetID
        parameters["start_date"] = formatter.string(from: startDate)
        parameters["end_date"] = formatter.string(from: endDate)
        self.parameters = parameters
    }
}
