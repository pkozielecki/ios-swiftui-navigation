//
//  FakeHistoricalAssetRatesProvider.swift
//  KISS Views
//

import Foundation

@testable import SwiftUI_Navigation

final actor FakeHistoricalAssetRatesProvider: HistoricalAssetRatesProvider {
    var simulatedHistoricalRates: [AssetHistoricalRate]?

    func getHistoricalRates(for assetID: String, range: ChartView.Scope) async -> [AssetHistoricalRate] {
        simulatedHistoricalRates ?? []
    }
}
