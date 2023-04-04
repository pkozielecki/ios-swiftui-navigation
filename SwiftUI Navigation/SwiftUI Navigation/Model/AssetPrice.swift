//
//  AssetPrice.swift
//  KISS Views
//

import Foundation

/// A structure describing asset price.
struct AssetPrice: Codable, Equatable, Hashable {

    /// An asset price relative to base asset.
    let value: Double

    /// A date of the exchange rate.
    let date: Date

    /// An asset used as base.
    let base: Asset
}

extension AssetPrice {

    var formattedPrice: String {
        String(format: "%.2f %@", 1 / value, base.id)
    }
}
