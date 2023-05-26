//
//  FlowCoordinator.swift
//  KISS Views
//

import ObjectiveC
import UIKit

/// An associated object key for a Flow Coordinator route.
private var FlowCoordinatorRouteKey: UInt8 = 234

/// An associated object key for a Flow Coordinator popup dismiss handler.
private var PopupDismissHandlerKey: UInt8 = 112

/// An abstraction describing a navigation flow.
protocol FlowCoordinator: ViewComponent, ViewComponentFactory, FlowCoordinatorFactory {

    /// A navigator the flow operates on.
    var navigator: Navigator { get }

    /// A parent flow coordinator.
    var parent: FlowCoordinator? { get }

    /// A child flow coordinator.
    var child: FlowCoordinator? { get }

    /// A coordinator completion callback.
    var completionCallback: (() -> Void)? { get set }

    /// A starts the flow.
    ///
    /// - Parameter animated: a flag indicating whether the flow should be started with animation.
    func start(animated: Bool)

    /// Stops the flow.
    func stop()

    /// Handles situation when child flow has finished.
    func handleChildCoordinatorFinished(executeBackNavigation: Bool)

    /// Shows a route in the flow.
    ///
    /// - Parameters:
    ///   - route: a route to show.
    ///   - withData: an optional data necessary to create a view.
    func show(route: any Route, withData: AnyHashable?)

    /// Checks whether a route can be shown in the flow.
    ///
    /// - Parameter route: a route to check.
    /// - Returns: a flag indicating whether a route can be shown in the flow.
    func canShow(route: any Route) -> Bool

    /// Switches to a route.
    func `switch`(toRoute route: any Route, withData: AnyHashable?)

    /// Navigates back one view.
    ///
    /// - Parameter animated: a flag indicating whether the navigation should be animated.
    func navigateBack(animated: Bool)

    /// Navigates back to the root view of the flow.
    ///
    /// - Parameter animated: a flag indicating whether the navigation should be animated.
    func navigateBackToRoot(animated: Bool)

    /// Navigates back to an already shown route.
    ///
    /// - Parameters:
    ///   - route: a route to navigate back to.
    ///   - animated: a flag indicating whether the navigation should be animated.
    func navigateBack(toRoute route: any Route, animated: Bool)
}

// MARK: - Default implementation

extension FlowCoordinator {

    /// - SeeAlso: ViewComponent.viewController
    var viewController: UIViewController {
        navigator.navigationStack
    }

    /// - SeeAlso: ViewComponent.route
    var route: any Route {
        get {
            objc_getAssociatedObject(self, &FlowCoordinatorRouteKey) as? any Route ?? EmptyRoute()
        }
        set {
            objc_setAssociatedObject(self, &FlowCoordinatorRouteKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    func show(route: any Route, withData: AnyHashable?) {
        guard canShow(route: route) else {
            return
        }

        if route.isFlow {
            if route.isPopup {
                createAndStartFlowOnPopup(withData: withData, route: route)
            } else {
                createAndStartInlineFlow(withData: withData, route: route)
            }
        } else {
            let viewComponents = makeViewComponents(forRoute: route, withData: withData)
            if viewComponents.count == 1, let viewComponent = viewComponents.first {
                show(viewComponent: viewComponent, route: route)
            } else {
                show(viewComponents: viewComponents, route: route)
            }
        }
    }

    func `switch`(toRoute route: any Route, withData: AnyHashable?) {
        // TODO: Implement switching between routes.
        // TODO: pass the request down the parent flow if needed.
    }

    func start() {
        start(animated: true)
    }

    func show(route: any Route) {
        show(route: route, withData: nil)
    }

    func `switch`(toRoute route: any Route) {
        `switch`(toRoute: route, withData: nil)
    }

    func navigateBack() {
        navigateBack(animated: true)
    }

    func navigateBackToRoot() {
        navigateBackToRoot(animated: true)
    }

    func navigateBack(toRoute route: any Route) {
        navigateBack(toRoute: route, animated: true)
    }
}

// MARK: - Private

private extension FlowCoordinator {

    // Discussion: If child coordinator is displayed as a popup, we want to capture it's manual dismissal (e.g. by dragging it down).
    // ... to do so, we need to subscribe to be a UIAdaptivePresentationControllerDelegate...
    // ... but a protocol cannot have default implementation of @objc methods defined in the delegate...
    // ... so we need to use this convenient wrapper and store it as an associated object.
    private var popupDismissHandler: PopupDismissHandler? {
        get {
            objc_getAssociatedObject(self, &PopupDismissHandlerKey) as? PopupDismissHandler
        }
        set {
            objc_setAssociatedObject(self, &PopupDismissHandlerKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    func createAndStartInlineFlow(withData: AnyHashable?, route: any Route) {
        let flowCoordinator = makeFlowCoordinator(
            forRoute: route,
            navigator: navigator,
            withData: withData
        )
        flowCoordinator.start(animated: true)
        flowCoordinator.route = route
        flowCoordinator.completionCallback = { [weak self] in
            self?.handleChildCoordinatorFinished(executeBackNavigation: true)
        }
    }

    func createAndStartFlowOnPopup(withData: AnyHashable?, route: any Route) {
        let navigationController = UINavigationController()
        navigationController.modalPresentationStyle = route.popupPresentationStyle.modalPresentationStyle
        let flowCoordinator = makeFlowCoordinator(
            forRoute: route,
            navigator: navigationController,
            withData: withData
        )
        flowCoordinator.start(animated: false)
        navigator.present(navigationController, animated: true, completion: nil)
        popupDismissHandler = PopupDismissHandler { [weak self] in
            self?.handleChildCoordinatorFinished(executeBackNavigation: false)
        }
        navigationController.presentationController?.delegate = popupDismissHandler
        flowCoordinator.route = route
        flowCoordinator.completionCallback = { [weak self] in
            self?.handleChildCoordinatorFinished(executeBackNavigation: true)
        }
    }

    func show(viewComponents: [ViewComponent], route: any Route) {
        if route.isPopup {
            //  Discussion: showing only the last view as popup.
            guard let last = viewComponents.last else {
                return
            }
            last.route = route
            navigator.present(last.viewController, animated: true, completion: nil)
        } else {
            var vcs = navigator.viewControllers
            let viewControllers = viewComponents.map { $0.viewController }
            viewControllers.forEach { $0.route = route }
            vcs.append(contentsOf: viewControllers)
            navigator.setViewControllers(vcs, animated: true)
        }
    }

    func show(viewComponent: ViewComponent, route: any Route) {
        viewComponent.route = route
        if route.isPopup {
            navigator.present(viewComponent.viewController, animated: true, completion: nil)
        } else {
            navigator.pushViewController(viewComponent.viewController, animated: true)
        }
    }
}
