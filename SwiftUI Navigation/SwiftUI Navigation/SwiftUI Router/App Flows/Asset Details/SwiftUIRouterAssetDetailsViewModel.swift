//
//  SwiftUIRouterAssetDetailsViewModel.swift
//  KISS Views
//

import Combine
import Foundation

/// A default AssetDetailsViewModel implementation.
final class SwiftUIRouterAssetDetailsViewModel: AssetDetailsViewModel {
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

private extension SwiftUIRouterAssetDetailsViewModel {

    @MainActor func loadAssetChart(scope: ChartView.Scope) async {
        let rates = await historicalAssetRatesProvider.getHistoricalRates(for: assetData.id, range: scope)
        let data = rates.map {
            ChartView.ChartPoint(label: $0.date, value: $0.value)
        }
        viewState = .loaded(data)
    }
}

extension SwiftUIRouterAssetDetailsViewModel {
    var viewStatePublished: Published<AssetDetailsViewState> { _viewState }
    var viewStatePublisher: Published<AssetDetailsViewState>.Publisher { $viewState }
}
