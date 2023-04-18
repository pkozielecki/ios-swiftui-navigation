//
//  PopupRoute.swift
//  KISS Views
//

import Foundation

/// A structure describing app popup route.
struct PopupRoute: Hashable, Codable, Identifiable {
    let popup: Popup

    var id: Int {
        popup.hashValue
    }
}

extension PopupRoute {

    static func makePopup(named popup: PopupRoute.Popup) -> PopupRoute {
        PopupRoute(popup: popup)
    }
}

extension PopupRoute {

    enum Popup: Hashable, Codable {

        case addAsset
        case homeView
    }
}
