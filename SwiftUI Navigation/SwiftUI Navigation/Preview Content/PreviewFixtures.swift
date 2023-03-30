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

    @Published var presentedAlert: AlertRoute?
    var presentedAlertPublished: Published<AlertRoute?> { _presentedAlert }
    var presentedAlertPublisher: Published<AlertRoute?>.Publisher { $presentedAlert }

    func set(navigationStack: [NavigationRoute]) {}

    func present(popup: PopupRoute.Popup) {}
    func dismiss() {}

    func push(screen: NavigationRoute.Screen) {}
    func pop() {}
    func popAll() {}

    func show(alert: AlertRoute.Alert) {}
    func hideCurrentAlert() {}
}

final class PreviewAddAssetViewModel: AddAssetViewModel {
    @Published var viewState: AddAssetViewState
    var viewStatePublished: Published<AddAssetViewState> { _viewState }
    var viewStatePublisher: Published<AddAssetViewState>.Publisher { $viewState }
    @Published var searchPhrase: String = ""
    var searchPhrasePublished: Published<String> { _searchPhrase }
    var searchPhrasePublisher: Published<String>.Publisher { $searchPhrase }
    var selectedAssetsIds: [String] = []

    init(state: AddAssetViewState) {
        viewState = state
    }

    func onAssetTapped(id: String) {}
    func onAssetsSelectionConfirmed() {}
}
