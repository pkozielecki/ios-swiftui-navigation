//
//  FakeAlertPresenter.swift
//  KISS Views
//

import UIKit

@testable import SwiftUI_Navigation

final class FakeAlertPresenter: AlertPresenter {

    func showInfoAlert(on viewController: UIViewController, title: String, message: String?, buttonTitle: String, completion: (() -> Void)?) {}

    func showAcceptanceAlert(on viewController: UIViewController, title: String, message: String?, yesActionTitle: String, noActionTitle: String, yesActionStyle: UIAlertAction.Style, noActionStyle: UIAlertAction.Style, completion: ((AcceptanceAlertAction) -> Void)?) {}
}
