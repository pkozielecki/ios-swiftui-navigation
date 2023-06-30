//
//  PopupRoute.swift
//  KISS Views
//

import Foundation

/// A structure describing app popup route.
enum PopupRoute: Hashable, Codable, Identifiable {
    case addAsset
    case homeView
    case appInfo // A placeholder popup screen - mostly for tests.

    var id: Int {
        hashValue
    }
}
