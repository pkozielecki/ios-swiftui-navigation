//
//  DefaultAlertPresenter.swift
//  KISS Views
//

import UIKit

/// A default implementation of AlertPresenter.
final class DefaultAlertPresenter: AlertPresenter {

    /// A currently displayed alert controller.
    private(set) var alertController: UIAlertController?

    /// - SeeAlso: AlertPresenter.showInfoAlert(on:title:message:buttonTitle:completion:)
    func showInfoAlert(
        on viewController: UIViewController,
        title: String,
        message: String?,
        buttonTitle: String,
        completion: (() -> Void)?
    ) {
        let okAction = UIAlertAction(title: buttonTitle, style: .default, handler: { _ in
            completion?()
        })
        showAlert(title: title, message: message, on: viewController, actions: [okAction])
    }

    /// - SeeAlso: AlertPresenter.showAcceptanceAlert(on:title:message:yesActionTitle:noActionTitle:yesActionStyle:noActionStyle:completion:)
    func showAcceptanceAlert(
        on viewController: UIViewController,
        title: String,
        message: String?,
        yesActionTitle: String,
        noActionTitle: String,
        yesActionStyle: UIAlertAction.Style,
        noActionStyle: UIAlertAction.Style,
        completion: ((AcceptanceAlertAction) -> Void)?
    ) {
        let yesAction = UIAlertAction(title: yesActionTitle, style: yesActionStyle, handler: { _ in
            completion?(.yes)
        })
        let noAction = UIAlertAction(title: noActionTitle, style: noActionStyle, handler: { _ in
            completion?(.no)
        })
        showAlert(title: title, message: message, on: viewController, actions: [yesAction, noAction])
    }
}

// MARK: - Private Methods

private extension DefaultAlertPresenter {

    func showAlert(title: String, message: String?, on viewController: UIViewController, actions: [UIAlertAction]) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        actions.forEach { alertController.addAction($0) }
        viewController.present(alertController, animated: true, completion: nil)
        self.alertController = alertController
    }
}
