//
//  FakeUIKitNavigationRouter.swift
//  KISS Views
//

import Foundation

@testable import SwiftUI_Navigation

final class FakeUIKitNavigationRouter: UIKitNavigationRouter {

    var currentFlow: FlowCoordinator?

    func show(route: any Route, withData: AnyHashable?) {}

    func `switch`(toRoute route: any Route, withData: AnyHashable?) {}

    func navigateBack(animated: Bool) {}

    func stopCurrentFlow() {}

    func navigateBackToRoot(animated: Bool) {}

    func navigateBack(toRoute route: any Route, animated: Bool) {}

    func start(initialFlow: FlowCoordinator, animated: Bool) {}
}
