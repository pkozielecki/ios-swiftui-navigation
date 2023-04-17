//
//  AssetDetailsViewModel.swift
//  KISS Views
//

import Combine
import Foundation

/// An enumeration describing AssetDetailsView state.
enum AssetDetailsViewState {
    case loading
    case loaded([ChartView.ChartPoint])
    case failed(String)
}

/// An abstraction describing a View Model for AssetDetailsView.
protocol AssetDetailsViewModel: ObservableObject {
    /// A view state.
    var viewState: AssetDetailsViewState { get }
    var viewStatePublished: Published<AssetDetailsViewState> { get }
    var viewStatePublisher: Published<AssetDetailsViewState>.Publisher { get }

    /// A basic asset data.
    var assetData: AssetDetailsViewData { get }

    /// Triggers editing of an asset.
    ///
    /// - Parameter assetID: a selected asset ID.
    func edit(asset assetID: String)

    /// Triggers reloading of a chart.
    ///
    /// - Parameter scope: a selected chart timing scope.
    func reloadChart(scope: ChartView.Scope)
}

/// A default AssetDetailsViewModel implementation.
final class DefaultAssetDetailsViewModel: AssetDetailsViewModel {
    @Published var viewState = AssetDetailsViewState.loading
    let assetData: AssetDetailsViewData

    private let router: any NavigationRouter
    private let favouriteAssetsManager: FavouriteAssetsManager

    /// A default initializer for AssetDetailsViewModel.
    ///
    /// - Parameter assetId: an asset id.
    /// - Parameter favouriteAssetsManager: a favourite assets manager.
    /// - Parameter router: a navigation router.
    init(
        assetId: String,
        favouriteAssetsManager: FavouriteAssetsManager,
        router: any NavigationRouter
    ) {
        let asset = favouriteAssetsManager.retrieveFavouriteAssets().filter { $0.id == assetId }.first
        assetData = asset?.toAssetDetailsViewData() ?? .empty
        self.favouriteAssetsManager = favouriteAssetsManager
        self.router = router
        viewState = .loading
        loadAssetChart()
    }

    /// - SeeAlso: AssetDetailsViewModel.edit(assetID:)
    func edit(asset assetID: String) {
        router.push(screen: .editAsset(assetID))
    }

    /// - SeeAlso: AssetDetailsViewModel.reloadChart(scope:)
    func reloadChart(scope: ChartView.Scope) {
        loadAssetChart()
    }
}

private extension DefaultAssetDetailsViewModel {

    func loadAssetChart() {

        // TODO: Replace with a call to actual BE.

        Task { @MainActor in
            try await Task.sleep(nanoseconds: 2000000000)
            var data: [ChartView.ChartPoint] = [
                .init(label: "jan/22", value: 5),
                .init(label: "feb/22", value: 4),
                .init(label: "mar/22", value: 7),
                .init(label: "apr/22", value: 15),
                .init(label: "may/22", value: 14),
                .init(label: "jun/22", value: 27),
                .init(label: "jul/22", value: 27)
            ]
            data.remove(at: Int.random(in: 0...data.count - 1))
            data.remove(at: Int.random(in: 0...data.count - 1))
            viewState = .loaded(data)
        }
    }
}

extension DefaultAssetDetailsViewModel {
    var viewStatePublished: Published<AssetDetailsViewState> { _viewState }
    var viewStatePublisher: Published<AssetDetailsViewState>.Publisher { $viewState }
}
