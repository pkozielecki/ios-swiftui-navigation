//
//  GetAllAssetsResponse.swift
//  KISS Views
//

import Foundation

/// A response structure for GetAllAssets request.
struct GetAllAssetsResponse: Codable, Equatable {
    let symbols: [String: String]
}

extension GetAllAssetsResponse {

    /// Convenience field converting retrieved assets into app internal format.
    var assets: [Asset] {
        symbols.map { key, value in
            Asset(id: key, name: value, colorCode: nil)
        }
    }
}
