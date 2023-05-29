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

    /// A route to add a new asset.
    case addAsset

    /// A route to show app info.
    case appInfo

    /// An embedded flow (brand new Main App flow embedded in the existing one):
    case embeddedMainAppFlow

    /// A main app flow presented as a popup:
    case popupMainAppFlow

    /// A hypothetical app route representing a drill-down navigation.
    /// E.g. showing immediately edit asset screen, but with go-back ability to go to asset details screen.
    case restoreNavigation(assetId: String)
}

extension MainAppRoute: Route {

    /// - SeeAlso: Route.path
    var name: String {
        switch self {
        case .assetsList:
            return "MainAppRoute.AssetsList"
        case .assetDetails:
            return "MainAppRoute.AssetDetails"
        case .editAsset:
            return "MainAppRoute.EditAsset"
        case .addAsset:
            return "MainAppRoute.AddAsset"
        case .appInfo:
            return "MainAppRoute.AppInfo"
        case .embeddedMainAppFlow:
            return "MainAppRoute.EmbeddedMainAppFlow"
        case .popupMainAppFlow:
            return "MainAppRoute.PopupMainAppFlow"
        case .restoreNavigation:
            return "MainAppRoute.RestoreNavigation"
        }
    }

    /// - SeeAlso: Route.isFlow
    var isFlow: Bool {
        switch self {
        case .embeddedMainAppFlow, .popupMainAppFlow, .addAsset, .appInfo:
            return true
        default:
            return false
        }
    }

    /// - SeeAlso: Route.popupPresentationStyle
    var popupPresentationStyle: PopupPresentationStyle {
        switch self {
        case .addAsset, .appInfo:
            return .modal
        case .popupMainAppFlow:
            return Bool.random() ? .fullScreen : .modal
        default:
            return .none
        }
    }
}
