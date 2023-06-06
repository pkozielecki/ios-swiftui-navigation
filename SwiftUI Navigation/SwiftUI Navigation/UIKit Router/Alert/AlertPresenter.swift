//
//  AlertPresenter.swift
//  KISS Views
//

import UIKit

/// An enumeration describing the possible actions user can perform on an acceptance alert.
enum AcceptanceAlertAction: Equatable {
    case yes, no
}

/// An abstraction describing an object that can present alerts.
protocol AlertPresenter: AnyObject {

    /// Shows a simple information alert.
    ///
    /// - Parameters:
    ///   - viewController: a view controller to show the alert on.
    ///   - title: an alert title.
    ///   - message: an alert message.
    ///   - buttonTitle: a title of the confirmation button.
    ///   - completion: a completion callback.
    func showInfoAlert(
        on viewController: UIViewController,
        title: String,
        message: String?,
        buttonTitle: String,
        completion: (() -> Void)?
    )

    /// Shows an acceptance alert.
    ///
    /// - Parameters:
    ///   - viewController: a view controller to show the alert on.
    ///   - title: an alert title.
    ///   - message: an alert message.
    ///   - yesActionTitle: a confirmation action button title.
    ///   - noActionTitle: a denial action button title.
    ///   - yesActionStyle: a confirmation action button style.
    ///   - noActionStyle: a denial action button style.
    ///   - completion: a completion callback.
    func showAcceptanceAlert(
        on viewController: UIViewController,
        title: String,
        message: String?,
        yesActionTitle: String,
        noActionTitle: String,
        yesActionStyle: UIAlertAction.Style,
        noActionStyle: UIAlertAction.Style,
        completion: ((AcceptanceAlertAction) -> Void)?
    )
}

extension AlertPresenter {

    /// A convenience method to show a simple information alert with a default button title.
    ///
    /// - Parameters:
    ///   - viewController: a view controller to show the alert on.
    ///   - title: an alert title.
    ///   - message: an alert message.
    ///   - completion: a completion callback.
    func showInfoAlert(
        on viewController: UIViewController,
        title: String,
        message: String?,
        completion: (() -> Void)?
    ) {
        showInfoAlert(
            on: viewController,
            title: title,
            message: message,
            buttonTitle: "OK",
            completion: completion
        )
    }

    /// A convenience method to show an acceptance alert with default button titles and styles.
    ///
    /// - Parameters:
    ///   - viewController: a view controller to show the alert on.
    ///   - title: an alert title.
    ///   - message: an alert message.
    ///   - completion: a completion callback.
    func showAcceptanceAlert(
        on viewController: UIViewController,
        title: String,
        message: String?,
        completion: ((AcceptanceAlertAction) -> Void)?
    ) {
        showAcceptanceAlert(
            on: viewController,
            title: title,
            message: message,
            yesActionTitle: "Yes",
            noActionTitle: "No",
            yesActionStyle: .default,
            noActionStyle: .default,
            completion: completion
        )
    }
}
