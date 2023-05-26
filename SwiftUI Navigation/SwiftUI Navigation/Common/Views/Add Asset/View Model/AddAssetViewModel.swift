//
//  AddAssetViewModel.swift
//  KISS Views
//

import Combine
import Foundation

/// An enumeration describing Add Asset View state.
enum AddAssetViewState {
    case loading
    case loaded([AssetCellView.Data])
    case noAssets
}

/// An abstraction describing a View Model for Add Asset View.
protocol AddAssetViewModel: ObservableObject {
    /// A view state.
    var viewState: AddAssetViewState { get }
    var viewStatePublished: Published<AddAssetViewState> { get }
    var viewStatePublisher: Published<AddAssetViewState>.Publisher { get }

    /// A search phrase.
    var searchPhrase: String { get set }
    var searchPhrasePublished: Published<String> { get }
    var searchPhrasePublisher: Published<String>.Publisher { get }

    /// A list of selected assets ids.
    var selectedAssetsIds: [String] { get }

    /// Executed on tapping an asset call.
    func onAssetTapped(id: String)

    /// Executed on confirming assets selection.
    func onAssetsSelectionConfirmed()
}
