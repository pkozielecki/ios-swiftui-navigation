//
//  SwiftUIRouterAppInfoViewModel.swift
//  KISS Views
//

import Combine
import SwiftUI

/// A default AppInfoViewModel implementation for SwiftUI navigation.
final class SwiftUIRouterAppInfoViewModel: AppInfoViewModel {
    @Published var viewState = AppInfoViewState.appUpToDate(currentVersion: "0.9")
    private let router: any SwiftUINavigationRouter

    /// A default initializer for AppInfoViewModel.
    ///
    /// - Parameter router: a navigation router.
    init(
        router: any SwiftUINavigationRouter
    ) {
        self.router = router
    }

    /// - SeeAlso: AppInfoViewModel.onAddAssetTapped()
    func addAssetTapped() {
        router.present(popup: .addAsset)
    }

    /// - SeeAlso: AppInfoViewModel.onAppUpdateTapped()
    func appUpdateTapped() {
        router.popAll()
        router.dismiss()
    }
}

extension SwiftUIRouterAppInfoViewModel {
    var viewStatePublished: Published<AppInfoViewState> { _viewState }
    var viewStatePublisher: Published<AppInfoViewState>.Publisher { $viewState }
}
