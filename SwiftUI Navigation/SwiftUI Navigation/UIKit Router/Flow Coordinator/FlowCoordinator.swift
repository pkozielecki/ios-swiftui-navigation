//
//  FlowCoordinator.swift
//  KISS Views
//

import ObjectiveC
import UIKit

/// An associated object key for a Flow Coordinator route.
private var FlowCoordinatorRouteKey: UInt8 = 234

/// An abstraction describing a navigation flow.
protocol FlowCoordinator: ViewComponent, ViewComponentFactory, FlowCoordinatorFactory, UIAdaptivePresentationControllerDelegate {

    /// A navigator the flow operates on.
    var navigator: Navigator { get }

    /// A parent flow coordinator.
    var parent: FlowCoordinator? { get }

    /// A child flow coordinator.
    var child: FlowCoordinator? { get }

    /// A presentation delegate.
    var adaptivePresentationDelegate: UIAdaptivePresentationControllerDelegate? { get set }

    /// A coordinator completion callback.
    var completionCallback: (() -> Void)? { get set }

    /// A starts the flow.
    ///
    /// - Parameter animated: a flag indicating whether the flow should be started with animation.
    func start(animated: Bool)

    /// Stops the flow.
    func stop()

    /// Handles situation when child flow has finished.
    func handleChildCoordinatorFinished()

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

    var viewController: UIViewController {
        navigator.navigationStack
    }

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

private extension FlowCoordinator {

    func createAndStartInlineFlow(withData: AnyHashable?, route: any Route) {
        let flowCoordinator = makeFlowCoordinator(
            forRoute: route,
            navigator: navigator,
            withData: withData
        )
        flowCoordinator.start(animated: true)
        flowCoordinator.route = route
        flowCoordinator.completionCallback = { [weak self] in
            self?.handleChildCoordinatorFinished()
        }
    }

    func createAndStartFlowOnPopup(withData: AnyHashable?, route: any Route) {
        let navigationController = UINavigationController()
        //  TODO: Handle fullscreen and popover presentation styles: navigationController.modalPresentationStyle = .fullScreen
        let flowCoordinator = makeFlowCoordinator(
            forRoute: route,
            navigator: navigationController,
            withData: withData
        )
        flowCoordinator.start(animated: false)
        navigator.present(navigationController, animated: true, completion: nil)
        navigationController.presentationController?.delegate = self
        flowCoordinator.route = route
        flowCoordinator.completionCallback = { [weak self] in
            self?.handleChildCoordinatorFinished()
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
