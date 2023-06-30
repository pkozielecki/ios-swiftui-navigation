//
//  AlertRoute.swift
//  KISS Views
//

import Foundation

/// A structure describing a route for an alert.
enum AlertRoute: Hashable, Codable, Identifiable {
    case deleteAsset(assetId: String, assetName: String)

    var id: Int {
        hashValue
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

extension AlertRoute: AlertRoutePresentable {

    /// - SeeAlso: AlertRoutePresentable.item
    var item: any Hashable {
        switch self {
        case let .deleteAsset(assetId, _):
            return assetId
        }
    }

    /// - SeeAlso: AlertRoutePresentable.title
    var title: String {
        switch self {
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
        switch self {
        case .deleteAsset:
            return "Delete"
        }
    }

    /// - SeeAlso: AlertRoutePresentable.cancellationActionText
    var cancellationActionText: String {
        "Cancel"
    }
}
