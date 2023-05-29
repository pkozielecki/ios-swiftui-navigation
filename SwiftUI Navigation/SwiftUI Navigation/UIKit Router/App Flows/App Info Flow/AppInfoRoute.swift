//
//  AppInfoRoute.swift
//  KISS Views
//

import Foundation

/// An enumeration describing a routes in App Info route.
enum AppInfoRoute {

    /// A route presenting app info.
    case appInfo
}

extension AppInfoRoute: Route {

    /// - SeeAlso: Route.path
    var name: String {
        switch self {
        case .appInfo:
            return "AppInfoRoute.AppInfo"
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
