//
//  AddAssetRoute.swift
//  KISS Views
//

import Foundation

/// An enumeration describing a routes in Add Asset flow.
enum AddAssetRoute {

    /// A route to add an asset.
    case addAsset
}

extension AddAssetRoute: Route {

    /// - SeeAlso: Route.path
    var name: String {
        switch self {
        case .addAsset:
            return "Add Asset"
        }
    }

    /// - SeeAlso: Route.isFlow
    var isFlow: Bool {
        false
    }

    /// - SeeAlso: Route.popupPresentationStyle
    var popupPresentationStyle: PopupPresentationStyle {
        .none
    }
}
