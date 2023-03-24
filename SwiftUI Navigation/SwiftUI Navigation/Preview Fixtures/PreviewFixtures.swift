//
//  PreviewFixtures.swift
//  KISS Views
//

import Combine
import Foundation
import SwiftUI
import UIKit

final class PreviewNavigationRouter: NavigationRouter {
    @Published var navigationRoute: NavigationRoute?
    var navigationPathPublished: Published<NavigationRoute?> { _navigationRoute }
    var navigationPathPublisher: Published<NavigationRoute?>.Publisher { $navigationRoute }
    private(set) var navigationStack: [NavigationRoute] = []

    @Published var presentedPopup: PopupRoute?
    var presentedPopupPublished: Published<PopupRoute?> { _presentedPopup }
    var presentedPopupPublisher: Published<PopupRoute?>.Publisher { $presentedPopup }

    func set(navigationStack: [NavigationRoute]) {}

    func present(popup: PopupRoute.Popup) {}
    func dismiss() {}

    func push(screen: NavigationRoute.Screen) {}
    func pop() {}
    func popAll() {}
}
