//
//  NavigationRoute.swift
//  KISS Views
//

import Foundation

/// A structure describing app navigation route.
struct NavigationRoute: Hashable, Codable, Identifiable {
    let id: UUID
    let screen: Screen
}

extension NavigationRoute {

    var presentationMode: PresentationMode {
        .inline
    }

    static func makeScreen(named screen: NavigationRoute.Screen) -> NavigationRoute {
        NavigationRoute(id: UUID(), screen: screen)
    }
}

extension NavigationRoute {

    enum Screen: Hashable, Codable {

        case assetCharts(String)
        case editAsset(String)
    }
}
