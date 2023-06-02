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
    private(set) var lastNavigatedBackAnimated: Bool?
    private(set) var lastNavigatedBackToRootAnimated: Bool?
    private(set) var lastNavigatedBackToRoute: (any Route)?
    private(set) var lastNavigatedBackToRouteAnimated: Bool?
    private(set) var lastDidStartAnimated: Bool?
    private(set) var lastDidStop: Bool?

    var navigator: Navigator {
        simulatedNavigator ?? UINavigationController()
    }

    var parent: FlowCoordinator? {
        simulatedParent
    }

    var child: FlowCoordinator?
    var completionCallback: (() -> Void)?

    func start(animated: Bool) {
        lastDidStartAnimated = animated
    }

    func stop() {
        lastDidStop = true
    }

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

    func navigateBack(animated: Bool) {
        lastNavigatedBackAnimated = animated
    }

    func navigateBackToRoot(animated: Bool) {
        lastNavigatedBackToRootAnimated = animated
    }

    func navigateBack(toRoute route: any Route, animated: Bool) {
        lastNavigatedBackToRoute = route
        lastNavigatedBackToRouteAnimated = animated
    }

    func makeViewComponents(forRoute route: any Route, withData: AnyHashable?) -> [ViewComponent] {
        []
    }

    func makeFlowCoordinator(forRoute route: any Route, navigator: Navigator, withData: AnyHashable?) -> FlowCoordinator {
        FakeFlowCoordinator()
    }
}
