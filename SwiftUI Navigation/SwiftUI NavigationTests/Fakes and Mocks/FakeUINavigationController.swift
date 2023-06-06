//
//  FakeUINavigationController.swift
//  KISS Views
//

import UIKit

final class FakeUINavigationController: UINavigationController {

    private(set) var lastPresentedViewController: UIViewController?

    override func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
        lastPresentedViewController = viewControllerToPresent
        super.present(viewControllerToPresent, animated: flag, completion: completion)
    }
}
