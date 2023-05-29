//
//  AssetsListViewModel.swift
//  KISS Views
//

import Combine
import Foundation

/// An enumeration describing Add Asset View state.
enum AssetsListViewState {
    case noFavouriteAssets
    case loading([FavouriteAssetCellView.Data])
    case loaded([FavouriteAssetCellView.Data], String)
}

/// An abstraction describing a View Model for .
protocol AssetsListViewModel: ObservableObject {
    /// A view state.
    var viewState: AssetsListViewState { get }
    var viewStatePublished: Published<AssetsListViewState> { get }
    var viewStatePublisher: Published<AssetsListViewState>.Publisher { get }

    /// Triggered on manual refresh requested.
    func onRefreshRequested()

    /// Triggerred on tapping Add Asset button.
    func onAddNewAssetTapped()

    /// Triggered on tapping App Info button.
    func onAppInfoTapped()

    /// Triggered on selecting an asset cell.
    ///
    /// - Parameter id: a selected asset id.
    func onAssetSelected(id: String)

    /// Triggered when user confirmed removal of an asset
    ///
    /// - Parameter id: an asset id.
    func removeAssetFromFavourites(id: String)

    /// Triggered on selecting an asset to be edited.
    ///
    /// - Parameter id: a selected asset id.
    func onAssetSelectedToBeEdited(id: String)

    /// Triggered on selecting an asset for removal.
    ///
    /// - Parameter id: a selected asset id.
    func onAssetSelectedForRemoval(id: String)
}

extension FavouriteAssetCellView.Data {
    init(asset: Asset) {
        self.init(id: asset.id, title: asset.name, color: asset.color, value: "...")
    }
}
