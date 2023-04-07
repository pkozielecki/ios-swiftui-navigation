//
//  EditAssetViewModel.swift
//  KISS Views
//

import Combine
import Foundation

/// An enumeration describing EditAssetView state.
enum EditAssetViewState {
    case loading
    case loaded
    case noAssets
}

/// An abstraction describing a View Model for EditAssetView.
protocol EditAssetViewModel: ObservableObject {
    /// A view state.
    var viewState: EditAssetViewState { get }
    var viewStatePublished: Published<EditAssetViewState> { get }
    var viewStatePublisher: Published<EditAssetViewState>.Publisher { get }

    var assetId: String { get }

    /// Pops to root view.
    func popToRoot()
}

/// A default EditAssetViewModel implementation.
final class DefaultEditAssetViewModel: EditAssetViewModel {
    @Published var viewState = EditAssetViewState.loading
    let assetId: String

    private let router: any NavigationRouter

    /// A default initializer for EditAssetViewModel.
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

    /// - SeeAlso: EditAssetViewModel.popToRoot()
    func popToRoot() {
        router.popAll()
    }
}

private extension DefaultEditAssetViewModel {

    enum Const {
        static let searchLatency = 0.3
    }
}

extension DefaultEditAssetViewModel {
    var viewStatePublished: Published<EditAssetViewState> { _viewState }
    var viewStatePublisher: Published<EditAssetViewState>.Publisher { $viewState }
}
