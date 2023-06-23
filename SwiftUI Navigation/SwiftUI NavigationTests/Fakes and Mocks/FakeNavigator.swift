//
//  FakeNavigator.swift
//  KISS Views
//

import UIKit
import XCTest

@testable import SwiftUI_Navigation

final class FakeNavigator: Navigator {
    var simulatedNavigationStack: UINavigationController?
    var simulatedTopViewController: UIViewController?
    var simulatedVisibleViewController: UIViewController?
    var simulatedViewControllers: [UIViewController] = []
    var simulatedIsNavigationBarHidden: Bool?
    var simulatedPresentedViewController: UIViewController?
    var simulatedPresentationController: UIPresentationController?
    var delegate: UINavigationControllerDelegate?

    private(set) var lastPushedViewController: UIViewController?
    private(set) var lastPushedViewControllerAnimation: Bool?
    private(set) var lastPoppedToViewControllerAnimation: Bool?
    private(set) var lastPoppedToViewController: UIViewController?
    private(set) var lastPresentedViewController: UIViewController?
    private(set) var lastPresentedViewControllerAnimation: Bool?
    private(set) var lastDismissedViewControllerAnimation: Bool?

    var navigationStack: UINavigationController {
        simulatedNavigationStack ?? UINavigationController()
    }

    var topViewController: UIViewController? {
        simulatedTopViewController
    }

    var visibleViewController: UIViewController? {
        simulatedVisibleViewController
    }

    var viewControllers: [UIViewController] {
        simulatedViewControllers
    }

    var isNavigationBarHidden: Bool {
        simulatedIsNavigationBarHidden ?? false
    }

    var presentedViewController: UIViewController? {
        simulatedPresentedViewController
    }

    var presentationController: UIPresentationController? {
        simulatedPresentationController
    }

    func pushViewController(_ viewController: UIViewController, animated: Bool) {
        simulatedViewControllers.append(viewController)
        lastPushedViewController = viewController
    }

    func popViewController(animated: Bool) -> UIViewController? {
        if !simulatedViewControllers.isEmpty {
            simulatedViewControllers.removeLast()
        }
        lastPoppedToViewControllerAnimation = animated
        return nil
    }

    func popToViewController(_ viewController: UIViewController, animated: Bool) -> [UIViewController]? {
        lastPoppedToViewController = viewController
        lastPoppedToViewControllerAnimation = animated
        let index = simulatedViewControllers.firstIndex(of: viewController) ?? 0
        simulatedViewControllers = Array(simulatedViewControllers[0...index])
        return nil
    }

    func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)?) {
        simulatedPresentedViewController = viewControllerToPresent
        lastPresentedViewController = viewControllerToPresent
        lastPresentedViewControllerAnimation = flag
        completion?()
    }

    func dismiss(animated flag: Bool, completion: (() -> Void)?) {
        simulatedPresentedViewController = nil
        lastDismissedViewControllerAnimation = flag
        completion?()
    }

    func setViewControllers(_ viewControllers: [UIViewController], animated: Bool) {
        simulatedViewControllers = viewControllers
    }

    func setNavigationBarHidden(_ hidden: Bool, animated: Bool) {
        simulatedIsNavigationBarHidden = hidden
    }
}

extension FakeNavigator {

    func simulateBackButtonTapped(viewToPopTo view: UIViewController, animated: Bool = false) {
        _ = simulatedViewControllers.popLast()
        delegate?.navigationController?(navigationStack, didShow: view, animated: animated)
    }
}
