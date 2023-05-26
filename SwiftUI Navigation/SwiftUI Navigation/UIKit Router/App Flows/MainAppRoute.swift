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
            return "Assets List"
        case .assetDetails:
            return "Asset Details"
        case .editAsset:
            return "Edit Asset"
        case .embeddedMainAppFlow:
            return "Embedded Main App flow"
        case .popupMainAppFlow:
            return "Popup Main App flow"
        case .restoreNavigation:
            return "Restore navigation"
        }
    }

    /// - SeeAlso: Route.isFlow
    var isFlow: Bool {
        switch self {
        case .embeddedMainAppFlow, .popupMainAppFlow:
            return true
        default:
            return false
        }
    }

    /// - SeeAlso: Route.popupPresentationStyle
    var popupPresentationStyle: PopupPresentationStyle {
        if case .popupMainAppFlow = self {
            // Discuss: Randomizing popup presentation style for showcase purposes only.
            return Bool.random() ? .fullScreen : .modal
        }
        return .none
    }
}
