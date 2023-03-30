//
//  Asset.swift
//  KISS Views
//

import Foundation

/// A simple model representing an asset.
struct Asset: Codable, Equatable, Hashable {
    /// An asset id, eg. USD, PLN, etc.
    let id: String

    /// An asset full name, eg. "US Dollar"
    let name: String
}
