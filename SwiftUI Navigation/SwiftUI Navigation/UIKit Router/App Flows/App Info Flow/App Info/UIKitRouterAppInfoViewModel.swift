//
//  UIKitRouterAppInfoViewModel.swift
//  KISS Views
//

import Combine
import UIKit

/// A default AppInfoViewModel implementation for UIKit navigation.
final class UIKitRouterAppInfoViewModel: AppInfoViewModel {
    @Published var viewState = AppInfoViewState.appUpToDate(currentVersion: "0.9")
//    @Published var viewState = AppInfoViewState.appUpdateAvailable(currentVersion: "0.9", availableVersion: "1.0")
    private let router: UIKitNavigationRouter

    /// A default initializer for AppInfoViewModel.
    ///
    /// - Parameter router: a navigation router.
    init(
        router: UIKitNavigationRouter
    ) {
        self.router = router
    }

    /// - SeeAlso: AppInfoViewModel.onAddAssetTapped()
    func addAssetTapped() {
        router.switch(toRoute: MainAppRoute.addAsset, withData: nil)
    }

    /// - SeeAlso: AppInfoViewModel.onAppUpdateTapped()
    func appUpdateTapped() {
        router.switch(toRoute: MainAppRoute.assetsList, withData: nil)
    }
}

extension UIKitRouterAppInfoViewModel {
    var viewStatePublished: Published<AppInfoViewState> { _viewState }
    var viewStatePublisher: Published<AppInfoViewState>.Publisher { $viewState }
}
