//
//  HistoricalAssetRatesProvider.swift
//  KISS Views
//

import ConcurrentNgNetworkModule
import Foundation
import NgNetworkModuleCore

/// An abstraction providing rates of exchange for favourite assets.
protocol HistoricalAssetRatesProvider: Actor {

    /// Retrieves historical exchange rates for an asset compared to the exchange base.
    ///
    /// - Returns: a collection of asset historical rates.
    func getHistoricalRates(for assetID: String, range: ChartView.Scope) async -> [AssetHistoricalRate]
}

/// A default HistoricalAssetRatesProvider implementation.
final actor DefaultHistoricalAssetRatesProvider: HistoricalAssetRatesProvider {
    private let networkModule: NetworkModule
    private let baseAssetProvider: BaseAssetProvider
    private let dateProvider: DateProvider

    /// A default initializer for DefaultHistoricalAssetRatesProvider.
    ///
    /// - Parameter networkModule: a networking module.
    /// - Parameter baseAssetProvider: a base asset provider.
    /// - Parameter dateProvider: a current date provider.
    init(
        networkModule: NetworkModule = NetworkingFactory.makeNetworkingModule(),
        baseAssetProvider: BaseAssetProvider = DefaultBaseAssetManager(),
        dateProvider: DateProvider = DefaultDateProvider()
    ) {
        self.networkModule = networkModule
        self.baseAssetProvider = baseAssetProvider
        self.dateProvider = dateProvider
    }

    /// - SeeAlso: HistoricalAssetRatesProvider.getAssetRates(assetID:range:)
    func getHistoricalRates(for assetID: String, range: ChartView.Scope) async -> [AssetHistoricalRate] {
        let baseAsset = baseAssetProvider.baseAsset
        let rangeDates = calculateStartEndDates(for: range)
        let request = GetHistoricalRatesRequest(
            assetID: assetID,
            base: baseAsset.id,
            startDate: rangeDates.0,
            endDate: rangeDates.1
        )
        do {
            let response = try await networkModule.performAndDecode(request: request, responseType: GetHistoricalAssetRatesResponse.self)
            return response.composeHistoricalAssetRates(for: assetID)
        } catch {
            return []
        }
    }
}

private extension DefaultHistoricalAssetRatesProvider {

    func calculateStartEndDates(for range: ChartView.Scope) -> (Date, Date) {
        let currentDate = dateProvider.currentDate()
        let endDate = Calendar.current.date(byAdding: .day, value: -1, to: currentDate) ?? currentDate

        switch range {
        case .week:
            let startDate = Calendar.current.date(byAdding: .day, value: -7, to: endDate) ?? endDate
            return (startDate, endDate)
        case .month:
            let startDate = Calendar.current.date(byAdding: .month, value: -1, to: endDate) ?? endDate
            return (startDate, endDate)
        case .quarter:
            let startDate = Calendar.current.date(byAdding: .month, value: -3, to: endDate) ?? endDate
            return (startDate, endDate)
        case .year:
            let startDate = Calendar.current.date(byAdding: .year, value: -1, to: endDate) ?? endDate
            return (startDate, endDate)
        }
    }
}
