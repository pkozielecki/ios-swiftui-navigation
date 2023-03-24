//
//  PopupRoute.swift
//  KISS Views
//

import Foundation

/// A structure describing app popup route.
struct PopupRoute: Hashable, Codable, Identifiable {
    let id: UUID
    let popup: Popup
}

extension PopupRoute {

    var presentationMode: PresentationMode {
        .popup
    }

    static func makePopup(named popup: PopupRoute.Popup) -> PopupRoute {
        PopupRoute(id: UUID(), popup: popup)
    }
}

extension PopupRoute {

    enum Popup: Hashable, Codable {

        case addAsset
    }
}
