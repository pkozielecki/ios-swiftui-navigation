//
//  NavigationRouter.swift
//  KISS Views
//

import Combine
import SwiftUI

/// An abstraction describing a navigation router.
/// It acts similarly to UINavigationController, allowing to push, present, pop and dismiss app views.
/// Requires a bound View able to produce the views to display e.g. `HomeView`
protocol NavigationRouter: AnyObject, ObservableObject {

    /// A currently presented popup.
    var presentedPopup: PopupRoute? { get set }
    var presentedPopupPublished: Published<PopupRoute?> { get }
    var presentedPopupPublisher: Published<PopupRoute?>.Publisher { get }

    /// A currently presented alert.
    var presentedAlert: AlertRoute? { get set }
    var presentedAlertPublished: Published<AlertRoute?> { get }
    var presentedAlertPublisher: Published<AlertRoute?>.Publisher { get }

    /// A currently presented navigation route.
    var navigationRoute: NavigationRoute? { get }

    /// A complete navigation stack.
    /// Contains all navigation routes pushed to navigation stack.
    var navigationStack: [NavigationRoute] { get }

    /// Pushes screen to navigation stack.
    ///
    /// - Parameter screen: a screen to be pushed.
    func push(screen: NavigationRoute.Screen)

    /// Removes last view from the navigation stack.
    func pop()

    /// Pops navigation stack to root.
    func popAll()

    /// Replaces navigation stack.
    ///
    /// - Parameter navigationStack: a collection of routes to replace the stack with.
    func set(navigationStack: [NavigationRoute])

    /// Presents provided popup as sheet.
    ///
    /// - Parameter popup: a popup to present.
    func present(popup: PopupRoute.Popup)

    /// Dismisses current popup.
    func dismiss()

    /// Shows an alert.
    ///
    /// - Parameter alert: an alert to show.
    func show(alert: AlertRoute.Alert)

    /// Removes currently displayed alert from the navigation stack.
    func hideCurrentAlert()
}

/// A default implementation of NavigationRouter.
final class DefaultNavigationRouter: NavigationRouter {
    @Published var presentedPopup: PopupRoute?
    var presentedPopupPublished: Published<PopupRoute?> { _presentedPopup }
    var presentedPopupPublisher: Published<PopupRoute?>.Publisher { $presentedPopup }

    @Published var presentedAlert: AlertRoute?
    var presentedAlertPublished: Published<AlertRoute?> { _presentedAlert }
    var presentedAlertPublisher: Published<AlertRoute?>.Publisher { $presentedAlert }

    var navigationRoute: NavigationRoute? {
        navigationStack.last
    }

    private(set) var navigationStack: [NavigationRoute] = []

    // MARK: - Popups:

    func present(popup: PopupRoute.Popup) {
        presentedPopup = .makePopup(named: popup)
    }

    func dismiss() {
        presentedPopup = nil
    }

    // MARK: - Inline navigation:

    func push(screen: NavigationRoute.Screen) {
        let route = NavigationRoute.makeScreen(named: screen)
        navigationStack.append(route)
        objectWillChange.send()
    }

    func pop() {
        guard !navigationStack.isEmpty else { return }
        navigationStack.removeLast()
        objectWillChange.send()
    }

    func popAll() {
        navigationStack = []
        objectWillChange.send()
    }

    func set(navigationStack: [NavigationRoute]) {
        self.navigationStack = navigationStack
        objectWillChange.send()
    }

    // MARK: - Alerts:

    func show(alert: AlertRoute.Alert) {
        presentedAlert = .makeAlert(named: alert)
    }

    func hideCurrentAlert() {
        presentedAlert = nil
    }
}
