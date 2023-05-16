//
//  MainAppRoute.swift
//  KISS Views
//

import UIKit

/// An enumeration describing a main app routes.
enum MainAppRoute {

    /// An Asset Lists view:
    case assetsList

    /// An Asset Details view:
    case assetDetails(assetId: String)

    /// An Edit Asset view:
    case editAsset(assetId: String)
}

extension MainAppRoute: Route {

    /// - SeeAlso: Route.path
    var name: String {
        switch self {
        case .assetsList:
            return "Assets List"
        case .assetDetails:
            return "Asset Details"
        case .editAsset:
            return "Edit Asset"
        }
    }

    /// - SeeAlso: Route.isFlow
    var isFlow: Bool {
        false
    }

    /// - SeeAlso: Route.isPopup
    var isPopup: Bool {
        if case .editAsset = self {
            return true
        }
        return false
    }
}
