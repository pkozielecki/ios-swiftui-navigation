//
//  NavigationRoute.swift
//  KISS Views
//

import Foundation

/// A structure describing app navigation route.
enum NavigationRoute: Hashable, Codable, Identifiable {
    case embeddedHomeView
    case assetDetails(String)
    case editAsset(String)

    var id: Int {
        hashValue
    }
}
