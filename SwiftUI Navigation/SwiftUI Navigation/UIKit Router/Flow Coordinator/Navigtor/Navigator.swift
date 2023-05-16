//
//  Navigator.swift
//  KISS Views
//

import UIKit

/// An abstraction describing an object allowing to execute navigation actions.
protocol Navigator: AnyObject {

    /// A navigation stack.
    var navigationStack: UINavigationController { get }

    /// A top view controller.
    var topViewController: UIViewController? { get }

    /// A visible view controller.
    var visibleViewController: UIViewController? { get }

    /// A list of view controllers on the navigation stack.
    var viewControllers: [UIViewController] { get }

    /// A flag indicating whether the navigation bar is hidden.
    var isNavigationBarHidden: Bool { get }

    func pushViewController(_ viewController: UIViewController, animated: Bool)
    func popViewController(animated: Bool) -> UIViewController?
    func popToViewController(_ viewController: UIViewController, animated: Bool) -> [UIViewController]?
    func popToRootViewController(animated: Bool) -> [UIViewController]?
    func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)?)
    func dismiss(animated flag: Bool, completion: (() -> Void)?)
    func setViewControllers(_ viewControllers: [UIViewController], animated: Bool)
    func setNavigationBarHidden(_ hidden: Bool, animated: Bool)
}

extension UINavigationController: Navigator {

    var navigationStack: UINavigationController {
        self
    }
}
