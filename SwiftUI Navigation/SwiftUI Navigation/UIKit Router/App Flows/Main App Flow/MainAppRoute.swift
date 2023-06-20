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

    /// A route to show app info as a standalone view.
    case appInfoStandalone

    /// An embedded flow (brand new Main App flow embedded in the existing one):
    case embeddedMainAppFlow

    /// An embedded flow showing app info.
    case appInfoEmbedded

    /// A main app flow presented as a popup:
    case popupMainAppFlow

    /// A hypothetical app route representing a drill-down navigation.
    /// E.g. showing immediately edit asset screen, but with go-back ability to go to asset details screen.
    case restoreNavigation(assetId: String)

    /// A hypothetical app route representing a single popup to be restored.
    /// As only one popup can be displayed at once, only the last view controller is restored.
    case restorePopupNavigation
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
        case .appInfoStandalone:
            return "MainAppRoute.AppInfoStandalone"
        case .appInfoEmbedded:
            return "MainAppRoute.AppInfoEmbedded"
        case .embeddedMainAppFlow:
            return "MainAppRoute.EmbeddedMainAppFlow"
        case .popupMainAppFlow:
            return "MainAppRoute.PopupMainAppFlow"
        case .restoreNavigation:
            return "MainAppRoute.RestoreNavigation"
        case .restorePopupNavigation:
            return "MainAppRoute.RestorePopupNavigation"
        }
    }

    /// - SeeAlso: Route.isFlow
    var isFlow: Bool {
        switch self {
        case .embeddedMainAppFlow, .popupMainAppFlow, .addAsset, .appInfo, .appInfoEmbedded:
            return true
        default:
            return false
        }
    }

    /// - SeeAlso: Route.popupPresentationStyle
    var popupPresentationStyle: PopupPresentationStyle {
        switch self {
        case .addAsset, .appInfo, .appInfoStandalone, .restorePopupNavigation:
            return .modal
        case .popupMainAppFlow:
            return Bool.random() ? .fullScreen : .modal
        default:
            return .none
        }
    }
}
