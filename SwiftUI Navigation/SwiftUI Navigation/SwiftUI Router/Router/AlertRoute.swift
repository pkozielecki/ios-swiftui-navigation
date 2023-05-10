//
//  AlertRoute.swift
//  KISS Views
//

import Foundation

/// A structure describing a route for an alert.
struct AlertRoute: Hashable, Codable, Identifiable {
    let alert: Alert

    var id: Int {
        alert.hashValue
    }
}

/// An abstraction describing a presentable alert route.
protocol AlertRoutePresentable {
    var item: any Hashable { get }
    var title: String { get }
    var message: String? { get }
    var confirmationActionText: String { get }
    var cancellationActionText: String { get }
}

extension AlertRoute {

    /// A helper method for creating an alert route.
    static func makeAlert(named alert: AlertRoute.Alert) -> AlertRoute {
        AlertRoute(alert: alert)
    }
}

extension AlertRoute {

    /// An enumeration describing an alert types.
    enum Alert: Hashable, Codable {

        case deleteAsset(assetId: String, assetName: String)
    }
}

extension AlertRoute: AlertRoutePresentable {

    /// - SeeAlso: AlertRoutePresentable.item
    var item: any Hashable {
        switch alert {
        case let .deleteAsset(assetId, _):
            return assetId
        }
    }

    /// - SeeAlso: AlertRoutePresentable.title
    var title: String {
        switch alert {
        case let .deleteAsset(_, assetName):
            return "Do you want to delete \(assetName)?"
        }
    }

    /// - SeeAlso: AlertRoutePresentable.message
    var message: String? {
        nil
    }

    /// - SeeAlso: AlertRoutePresentable.confirmationActionText
    var confirmationActionText: String {
        switch alert {
        case .deleteAsset:
            return "Delete"
        }
    }

    /// - SeeAlso: AlertRoutePresentable.cancellationActionText
    var cancellationActionText: String {
        "Cancel"
    }
}
