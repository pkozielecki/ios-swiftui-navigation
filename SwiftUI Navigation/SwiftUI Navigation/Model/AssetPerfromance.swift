//
//  AssetPerfromance.swift
//  KISS Views
//

import Foundation

struct AssetPerformance: Codable, Equatable, Hashable {
    /// An asset id, eg. USD, PLN, etc.
    let id: String

    /// An asset full name, eg. "US Dollar"
    let name: String

    /// A current asset price.
    let price: AssetPrice?
}
