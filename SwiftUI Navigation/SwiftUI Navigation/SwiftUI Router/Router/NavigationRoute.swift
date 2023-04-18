//
//  NavigationRoute.swift
//  KISS Views
//

import Foundation

/// A structure describing app navigation route.
struct NavigationRoute: Hashable, Codable, Identifiable {
    let screen: Screen

    var id: Int {
        screen.hashValue
    }
}

extension NavigationRoute {

    static func makeScreen(named screen: NavigationRoute.Screen) -> NavigationRoute {
        NavigationRoute(screen: screen)
    }
}

extension NavigationRoute {

    enum Screen: Hashable, Codable {
        case embeddedHomeView
        case assetDetails(String)
        case editAsset(String)
    }
}
