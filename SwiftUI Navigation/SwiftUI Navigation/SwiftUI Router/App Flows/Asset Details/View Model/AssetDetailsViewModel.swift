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
    func reloadChart(scope: ChartView.Scope) async

    /// Shows initial asset performance chart.
    func showInitialChart() async
}

/// A default AssetDetailsViewModel implementation.
final class DefaultAssetDetailsViewModel: AssetDetailsViewModel {
    @Published var viewState = AssetDetailsViewState.loading
    let assetData: AssetDetailsViewData

    private let router: any SwiftUINavigationRouter
    private let favouriteAssetsManager: FavouriteAssetsManager
    private let historicalAssetRatesProvider: HistoricalAssetRatesProvider

    /// A default initializer for AssetDetailsViewModel.
    ///
    /// - Parameter assetId: an asset id.
    /// - Parameter favouriteAssetsManager: a favourite assets manager.
    /// - Parameter historicalAssetRatesProvider: a historical asset rates provder.
    /// - Parameter router: a navigation router.
    init(
        assetId: String,
        favouriteAssetsManager: FavouriteAssetsManager,
        historicalAssetRatesProvider: HistoricalAssetRatesProvider,
        router: any SwiftUINavigationRouter
    ) {
        let asset = favouriteAssetsManager.retrieveFavouriteAssets().filter { $0.id == assetId }.first
        assetData = asset?.toAssetDetailsViewData() ?? .empty
        self.favouriteAssetsManager = favouriteAssetsManager
        self.historicalAssetRatesProvider = historicalAssetRatesProvider
        self.router = router
        viewState = .loading
    }

    /// - SeeAlso: AssetDetailsViewModel.edit(assetID:)
    func edit(asset assetID: String) {
        router.push(screen: .editAsset(assetID))
    }

    /// - SeeAlso: AssetDetailsViewModel.reloadChart(scope:)
    func reloadChart(scope: ChartView.Scope) async {
        await loadAssetChart(scope: scope)
    }

    /// - SeeAlso: AssetDetailsViewModel.showInitialChart()
    func showInitialChart() async {
        await loadAssetChart(scope: .week)
    }
}

private extension DefaultAssetDetailsViewModel {

    @MainActor func loadAssetChart(scope: ChartView.Scope) async {
        let rates = await historicalAssetRatesProvider.getHistoricalRates(for: assetData.id, range: scope)
        let data = rates.map {
            ChartView.ChartPoint(label: $0.date, value: $0.value)
        }
        viewState = .loaded(data)
    }
}

extension DefaultAssetDetailsViewModel {
    var viewStatePublished: Published<AssetDetailsViewState> { _viewState }
    var viewStatePublisher: Published<AssetDetailsViewState>.Publisher { $viewState }
}
