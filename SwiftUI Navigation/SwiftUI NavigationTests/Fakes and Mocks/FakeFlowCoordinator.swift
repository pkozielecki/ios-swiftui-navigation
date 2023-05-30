//
//  FakeFlowCoordinator.swift
//  KISS Views
//

import UIKit

@testable import SwiftUI_Navigation

final class FakeFlowCoordinator: FlowCoordinator {
    var simulatedNavigator: FakeNavigator?
    var simulatedParent: FlowCoordinator?
    var simulatedCanShow: Bool?

    private(set) var lastSwitchedToRoute: (any Route)?
    private(set) var lastSwitchedToRouteData: AnyHashable?
    private(set) var lastShownRoute: (any Route)?
    private(set) var lastShownRouteData: AnyHashable?

    var navigator: Navigator {
        simulatedNavigator ?? UINavigationController()
    }

    var parent: FlowCoordinator? {
        simulatedParent
    }

    var child: FlowCoordinator?
    var completionCallback: (() -> Void)?

    func start(animated: Bool) {}

    func stop() {}

    func canShow(route: any Route) -> Bool {
        simulatedCanShow ?? false
    }

    func show(route: any Route, withData: AnyHashable?) {
        lastShownRoute = route
        lastShownRouteData = withData
    }

    func `switch`(toRoute route: any Route, withData: AnyHashable?) {
        lastSwitchedToRoute = route
        lastSwitchedToRouteData = withData
    }

    func navigateBack(animated: Bool) {}

    func navigateBackToRoot(animated: Bool) {}

    func navigateBack(toRoute route: any Route, animated: Bool) {}

    func makeViewComponents(forRoute route: any Route, withData: AnyHashable?) -> [ViewComponent] {
        []
    }

    func makeFlowCoordinator(forRoute route: any Route, navigator: Navigator, withData: AnyHashable?) -> FlowCoordinator {
        FakeFlowCoordinator()
    }
}
