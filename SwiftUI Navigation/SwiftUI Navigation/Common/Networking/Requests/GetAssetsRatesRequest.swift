//
//  GetAssetsRatesRequest.swift
//  KISS Views
//

import Foundation
import NgNetworkModuleCore

/// A request fetching selected assets rate.
struct GetAssetsRatesRequest: NetworkRequest {
    let path = "v1/latest"
    let method = NetworkRequestType.get
    let requiresAuthenticationToken = true
    let parameters: [String: String]?

    /// A default GetAssetsRatesRequest initializer.
    ///
    /// - Parameters:
    ///   - assetIDs: a collection of asset IDs to get rates for.
    ///   - base: an ID of an asset base to calculate rated for.
    init(assetIDs: [String], base: String) {
        var parameters = [String: String]()
        parameters["base"] = base
        parameters["currencies"] = assetIDs.joined(separator: ",")
        self.parameters = parameters
    }
}
