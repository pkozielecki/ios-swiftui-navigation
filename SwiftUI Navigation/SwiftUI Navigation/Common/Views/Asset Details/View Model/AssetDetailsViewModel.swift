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
