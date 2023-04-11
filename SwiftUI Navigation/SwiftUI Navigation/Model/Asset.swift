//
//  Asset.swift
//  KISS Views
//

import SwiftUI

/// A simple model representing an asset.
struct Asset: Codable, Equatable, Hashable {
    /// An asset id, eg. USD, PLN, etc.
    let id: String

    /// An asset full name, eg. "US Dollar".
    let name: String

    /// A background color distinguishing an asset.
    let colorCode: String?
}

extension Asset {

    /// A helper value representing a color associated with the asset.
    var color: Color {
        guard let colorCode else {
            return .primary
        }
        return Color(hex: colorCode)
    }
}
