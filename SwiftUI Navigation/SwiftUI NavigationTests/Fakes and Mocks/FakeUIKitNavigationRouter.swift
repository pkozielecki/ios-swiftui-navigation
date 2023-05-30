//
//  FakeUIKitNavigationRouter.swift
//  KISS Views
//

import Foundation

@testable import SwiftUI_Navigation

final class FakeUIKitNavigationRouter: UIKitNavigationRouter {

    func show(route: any Route, withData: AnyHashable?) {}

    func `switch`(toRoute route: any Route, withData: AnyHashable?) {}

    func navigateBack(animated: Bool) {}

    func stop() {}

    func navigateBackToRoot(animated: Bool) {}

    func navigateBack(toRoute route: any Route, animated: Bool) {}

    func start(initialFlow: FlowCoordinator, animated: Bool) {}
}
