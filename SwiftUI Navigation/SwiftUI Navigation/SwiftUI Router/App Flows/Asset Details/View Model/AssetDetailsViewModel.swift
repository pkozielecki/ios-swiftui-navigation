//
//  AssetDetailsViewModel.swift
//  KISS Views
//

import Combine
import Foundation

/// An enumeration describing AssetDetailsView state.
enum AssetDetailsViewState {
    case loading
    case loaded
    case noAssets
}

/// An abstraction describing a View Model for AssetDetailsView.
protocol AssetDetailsViewModel: ObservableObject {
    /// A view state.
    var viewState: AssetDetailsViewState { get }
    var viewStatePublished: Published<AssetDetailsViewState> { get }
    var viewStatePublisher: Published<AssetDetailsViewState>.Publisher { get }

    var assetId: String { get }
}

/// A default AssetDetailsViewModel implementation.
final class DefaultAssetDetailsViewModel: AssetDetailsViewModel {
    @Published var viewState = AssetDetailsViewState.loading
    let assetId: String

    private let router: any NavigationRouter

    /// A default initializer for AssetDetailsViewModel.
    ///
    /// - Parameter assetId: an asset id.
    /// - Parameter router: a navigation router.
    init(
        assetId: String,
        router: any NavigationRouter
    ) {
        self.assetId = assetId
        self.router = router
        viewState = .loading
    }
}

private extension DefaultAssetDetailsViewModel {

    enum Const {
        static let searchLatency = 0.3
    }
}

extension DefaultAssetDetailsViewModel {
    var viewStatePublished: Published<AssetDetailsViewState> { _viewState }
    var viewStatePublisher: Published<AssetDetailsViewState>.Publisher { $viewState }
}
