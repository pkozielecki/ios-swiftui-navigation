//
//  AlertRoute.swift
//  KISS Views
//

import Foundation

/// A structure describing an app alert route.
struct AlertRoute: Hashable, Codable, Identifiable {
    let id: UUID
    let alert: Alert
}

protocol AlertRoutePresentable {
    var item: any Hashable { get }
    var title: String { get }
    var message: String? { get }
}

extension AlertRoute {

    static func makeAlert(named alert: AlertRoute.Alert) -> AlertRoute {
        AlertRoute(id: UUID(), alert: alert)
    }
}

extension AlertRoute {

    enum Alert: Hashable, Codable {

        case deleteAsset(assetId: String, assetName: String)
    }
}

extension AlertRoute: AlertRoutePresentable {

    var item: any Hashable {
        switch alert {
        case let .deleteAsset(assetId, _):
            return assetId
        }
    }

    var title: String {
        switch alert {
        case let .deleteAsset(_, assetName):
            return "Do you want to delete \(assetName)?"
        }
    }

    var message: String? {
        nil
    }
}
