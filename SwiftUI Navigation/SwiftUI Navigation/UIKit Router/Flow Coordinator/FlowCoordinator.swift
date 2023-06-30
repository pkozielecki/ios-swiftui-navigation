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

private var NavigationStackChangesHandlerKey: UInt8 = 212
// private var NavigationStackChangesPreviousHandlerKey: UInt8 = 214

/// An associated object key for a Flow Coordinator popup dismiss in progress flag.
private var PopupDismissInProgressKey: UInt8 = 113

/// An associated object key for a Flow Coordinator initial internal route.
private var FlowCoordinatorInitialInternalRoute: UInt8 = 119

/// An abstraction describing a navigation flow.
protocol FlowCoordinator: ViewComponent, ViewComponentFactory, FlowCoordinatorFactory {

    /// A navigator the flow operates on.
    var navigator: Navigator { get }

    /// A parent flow coordinator.
    var parent: FlowCoordinator? { get }

    /// A child flow coordinator.
    /// Important: It's NOT recommended to set child manually OUTSIDE of a given FlowCoordinator!
    /// The setter is exposed only to set Flow's child to nil after it's finished.
    var child: FlowCoordinator? { get set }

    /// A coordinator completion callback.
    var completionCallback: (() -> Void)? { get set }

    /// A starts the flow.
    ///
    /// - Parameter animated: a flag indicating whether the flow should be started with animation.
    func start(animated: Bool)

    /// Stops the flow.
    func stop()

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
    /// - Parameter dismissPopup: a flag indicating whether the popup should be dismissed.
    func navigateBackToRoot(animated: Bool, dismissPopup: Bool)

    /// Navigates back to an already shown route.
    ///
    /// - Parameters:
    ///   - route: a route to navigate back to.
    ///   - animated: a flag indicating whether the navigation should be animated.
    ///   - dismissPopup: a flag indicating whether the popup should be dismissed.
    func navigateBack(toRoute route: any Route, animated: Bool, dismissPopup: Bool)
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

    /// A route that is internally displayed by the flow coordinator (at root).
    var initialInternalRoute: (any Route)? {
        get {
            objc_getAssociatedObject(self, &FlowCoordinatorInitialInternalRoute) as? any Route
        }
        set {
            objc_setAssociatedObject(self, &FlowCoordinatorInitialInternalRoute, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    /// - SeeAlso: FlowCoordinator.show(route:withData:)
    func show(route: any Route, withData: AnyHashable?) {
        guard canShow(route: route) else {
            return
        }
        if initialInternalRoute == nil {
            initialInternalRoute = route
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
                // There is only a single view to show (99% of cases):
                viewComponent.route = route
                show(viewComponent: viewComponent, asPopup: route.isPopup)
            } else if !route.isPopup {
                // There are more views to show, but inline (not on a popup):
                showInline(viewComponents: viewComponents)
            } else if let last = viewComponents.last {
                // Discussion: There are more views to show on a popup, but not defined as a flow.
                // It's a hypothetical case, but we handle it anyway:
                show(viewComponent: last, asPopup: true)
            }
        }
    }

    /// - SeeAlso: FlowCoordinator.switch(route:withData:)
    func `switch`(toRoute route: any Route, withData: AnyHashable?) {
        if canShow(route: route) {
            if isShowing(route: route) {
                child?.stop()
                navigateBack(toRoute: route)
            } else {
                // Discussion: If the desired route is NOT a popup and current child flow is displayed on a popup:
                if !route.isPopup, child?.route.isPopup == true {
                    child?.stop()
                }

                navigateBackToRoot(animated: true, dismissPopup: false)
                show(route: route, withData: withData)
            }
        } else if let parent = parent {
            parent.switch(toRoute: route, withData: withData)
        } else {
            fatalError("`Switch` to route is not implemented not handled properly.")
        }
    }

    /// - SeeAlso: FlowCoordinator.start()
    func start() {
        start(animated: true)
    }

    /// - SeeAlso: FlowCoordinator.show(route:)
    func show(route: any Route) {
        show(route: route, withData: nil)
    }

    /// - SeeAlso: FlowCoordinator.switch(route:)
    func `switch`(toRoute route: any Route) {
        `switch`(toRoute: route, withData: nil)
    }

    /// - SeeAlso: FlowCoordinator.navigateBack()
    func navigateBack() {
        navigateBack(animated: true)
    }

    /// - SeeAlso: FlowCoordinator.navigateBack(animated:)
    func navigateBack(animated: Bool) {
        if navigator.presentedViewController != nil {
            dismissPopupIfNeeded(animated: animated)
        } else {
            // Discussion: We are currently at the initial view of the flow and going back == stopping the flow:
            if let route = initialInternalRoute, navigator.topViewController?.route.matches(route) == true {
                stop()
            } else {
                _ = navigator.popViewController(animated: animated)
            }
        }
    }

    /// - SeeAlso: FlowCoordinator.navigateBackToRoot()
    func navigateBackToRoot() {
        navigateBackToRoot(animated: true, dismissPopup: true)
    }

    /// - SeeAlso: FlowCoordinator.navigateBackToRoot(animated:dismissPopup:)
    func navigateBackToRoot(animated: Bool, dismissPopup: Bool) {
        guard let initialRoute = initialInternalRoute else {
            fatalError("No initial route defined.")
        }
        navigateBack(toRoute: initialRoute, animated: animated, dismissPopup: dismissPopup)
    }

    /// - SeeAlso: FlowCoordinator.navigateBack(route:)
    func navigateBack(toRoute route: any Route) {
        navigateBack(toRoute: route, animated: true, dismissPopup: true)
    }

    /// - SeeAlso: FlowCoordinator.navigateBack(route:animated:)
    func navigateBack(toRoute route: any Route, animated: Bool, dismissPopup: Bool) {
        // Discussion: Affects only this coordinator - does not recurse to parent.
        // Use switch(toRoute:) to check also parent coordinators
        if navigator.presentedViewController?.route.matches(route) == true {
            return
        }
        if !navigator.contains(route: route) {
            return
        }

        if dismissPopup {
            dismissPopupIfNeeded(animated: animated)
        }

        // Traverse navigation stack to find a view controller matching the route.
        for viewController in navigator.viewControllers.reversed() {
            if viewController.route.matches(route) {
                _ = navigator.popToViewController(viewController, animated: animated)
                break
            }
        }
    }

    /// A helper method to remove all flow views from the navigation stack.
    /// If a flow initial view is a root view of a given `Navigator`, it won't be removed.
    ///
    /// - Parameter animated: A flag indicating if the transition should be animated.
    func cleanUpNavigationStack(animated: Bool = true) {
        if let initialInternalRoute,
           let rootViewIndex = navigator.index(for: initialInternalRoute),
           rootViewIndex > 0 {
            _ = navigator.popToViewController(navigator.viewControllers[rootViewIndex - 1], animated: animated)
        } else {
            navigateBackToRoot(animated: animated, dismissPopup: true)
        }
    }
}

// MARK: - Private

private extension FlowCoordinator {

    // Discussion: If child coordinator is displayed as a popup, we want to capture it's manual dismissal (e.g. by dragging it down).
    // ... to do so, we need to subscribe to be a UIAdaptivePresentationControllerDelegate...
    // ... but a protocol cannot have default implementation of @objc methods defined in the delegate...
    // ... so we need to use this convenient wrapper and store it as an associated object.
    var popupDismissHandler: PopupDismissHandler? {
        get {
            objc_getAssociatedObject(self, &PopupDismissHandlerKey) as? PopupDismissHandler
        }
        set {
            objc_setAssociatedObject(self, &PopupDismissHandlerKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    var navigationStackChangesHandler: NavigationStackChangesHandler? {
        get {
            objc_getAssociatedObject(self, &NavigationStackChangesHandlerKey) as? NavigationStackChangesHandler
        }
        set {
            objc_setAssociatedObject(self, &NavigationStackChangesHandlerKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    var isDismissingPopup: Bool {
        get {
            objc_getAssociatedObject(self, &PopupDismissInProgressKey) as? Bool ?? false
        }
        set {
            objc_setAssociatedObject(self, &PopupDismissInProgressKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
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
            self?.navigator.delegate = self?.navigationStackChangesHandler
            self?.child = nil
        }
        let stackChangesHandler = NavigationStackChangesHandler { [weak self, weak flowCoordinator] route in
            // Discussion: We show route NOT supported by the flow, but supported by its parent
            // ... == we went beyond the child flow's scope.
            let parentFlowCanShow = self?.canShow(route: route) ?? false
            let childFlowCanShow = flowCoordinator?.canShow(route: route) ?? true
            if !childFlowCanShow, parentFlowCanShow {
                flowCoordinator?.stop()
            }
        }
        flowCoordinator.navigationStackChangesHandler = stackChangesHandler
        navigator.delegate = stackChangesHandler
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
        // Discussion: If there is a popup already presented, we need to dismiss it first:
        if navigator.presentedViewController != nil {
            navigator.dismiss(animated: true) { [weak self] in
                self?.navigator.present(navigationController, animated: true, completion: nil)
            }
        } else {
            navigator.present(navigationController, animated: true, completion: nil)
        }
        popupDismissHandler = PopupDismissHandler { [weak self] in
            self?.child = nil
        }
        navigationController.presentationController?.delegate = popupDismissHandler
        flowCoordinator.route = route
        flowCoordinator.completionCallback = { [weak self] in
            self?.navigateBack()
            self?.child = nil
        }
    }

    func show(viewComponent: ViewComponent, asPopup: Bool) {
        if asPopup {
            showAsPopup(viewComponent: viewComponent)
        } else {
            navigator.pushViewController(viewComponent.viewController, animated: true)
        }
    }

    func showInline(viewComponents: [ViewComponent]) {
        var currentViewControllers = navigator.viewControllers
        let viewControllers = viewComponents.map { $0.viewController }
        currentViewControllers.append(contentsOf: viewControllers)
        navigator.setViewControllers(currentViewControllers, animated: true)
    }

    func showAsPopup(viewComponent: ViewComponent) {
        if navigator.presentedViewController != nil {
            navigator.dismiss(animated: true) { [weak self] in
                self?.navigator.present(viewComponent.viewController, animated: true, completion: nil)
            }
        } else {
            navigator.present(viewComponent.viewController, animated: true, completion: nil)
        }
    }

    func dismissPopupIfNeeded(animated: Bool) {
        if navigator.presentedViewController == nil {
            return
        }
        if !isDismissingPopup {
            isDismissingPopup = true
            navigator.dismiss(animated: animated) { [weak self] in
                self?.isDismissingPopup = false
            }
        }
    }

    func isShowing(route: any Route) -> Bool {
        if let popup = navigator.presentedViewController, popup.route.matches(route) {
            return true
        }

        return navigator.contains(route: route)
    }
}
