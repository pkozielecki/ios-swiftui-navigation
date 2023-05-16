//
//  EditAssetViewModel.swift
//  KISS Views
//

import Combine
import SwiftUI

/// An enumeration describing EditAssetView state.
enum EditAssetViewState {
    case editAsset(EditAssetViewData)
    case assetNotFound
}

/// An abstraction describing a View Model for EditAssetView.
protocol EditAssetViewModel: ObservableObject {
    /// A view state.
    var viewState: EditAssetViewState { get }
    var viewStatePublished: Published<EditAssetViewState> { get }
    var viewStatePublisher: Published<EditAssetViewState>.Publisher { get }

    /// Saves current changes.
    ///
    /// - Parameter assetData: an asset data.
    func saveChanges(assetData: EditAssetViewData)
}
