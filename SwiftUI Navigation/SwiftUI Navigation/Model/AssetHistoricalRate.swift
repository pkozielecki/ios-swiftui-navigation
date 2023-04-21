//
//  AssetHistoricalRate.swift
//  KISS Views
//

import Foundation

struct AssetHistoricalRate: Codable, Equatable, Hashable {
    /// An asset id, eg. USD, PLN, etc.
    let id: String

    /// A rate snapshot date.
    let date: String

    /// An asset price in the moment of snapshot.
    let value: Double
}
