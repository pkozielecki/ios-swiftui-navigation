//
//  FakeAssetsRatesProvider.swift
//  KISS Views
//

import Foundation

@testable import SwiftUI_Navigation

final actor FakeAssetsRatesProvider: AssetsRatesProvider {
    var simulatedAssetPerformance: [AssetPerformance]?

    func getAssetRates() async -> [AssetPerformance] {
        simulatedAssetPerformance ?? []
    }
}
