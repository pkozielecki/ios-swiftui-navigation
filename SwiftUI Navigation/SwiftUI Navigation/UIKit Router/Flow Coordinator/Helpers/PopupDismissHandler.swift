//
//  PopupDismissHandler.swift
//  KISS Views
//

import UIKit

/// A simple handler for popup dismissal.
final class PopupDismissHandler: NSObject, UIAdaptivePresentationControllerDelegate {
    private let onDismiss: (() -> Void)?

    /// A default initializer for PopupDismissHandler.
    ///
    /// - Parameter onDismiss: a callback to be executed on delegate call.
    init(onDismiss: (() -> Void)?) {
        self.onDismiss = onDismiss
    }

    /// - SeeAlso: UIAdaptivePresentationControllerDelegate.presentationControllerDidDismiss(_:)
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        onDismiss?()
    }
}
