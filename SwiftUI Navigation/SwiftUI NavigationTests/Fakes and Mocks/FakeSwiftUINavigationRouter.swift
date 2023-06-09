//
//  FakeSwiftUINavigationRouter.swift
//  KISS Views
//

import Foundation

@testable import SwiftUI_Navigation

final class FakeSwiftUINavigationRouter: SwiftUINavigationRouter {
    @Published var navigationRoute: NavigationRoute?
    @Published var presentedPopup: PopupRoute?
    @Published var presentedAlert: AlertRoute?

    private(set) var navigationStack: [NavigationRoute] = []

    func set(navigationStack: [NavigationRoute]) {
        self.navigationStack = navigationStack
    }
}

extension FakeSwiftUINavigationRouter {
    var navigationPathPublished: Published<NavigationRoute?> { _navigationRoute }
    var navigationPathPublisher: Published<NavigationRoute?>.Publisher { $navigationRoute }
    var presentedPopupPublished: Published<PopupRoute?> { _presentedPopup }
    var presentedPopupPublisher: Published<PopupRoute?>.Publisher { $presentedPopup }
    var presentedAlertPublished: Published<AlertRoute?> { _presentedAlert }
    var presentedAlertPublisher: Published<AlertRoute?>.Publisher { $presentedAlert }

    func present(popup: PopupRoute) {}
    func dismiss() {}
    func push(route: NavigationRoute) {}
    func pop() {}
    func popAll() {}
    func show(alert: AlertRoute) {}
    func hideCurrentAlert() {}
}
