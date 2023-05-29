//
//  UIKitRouterAddAssetViewModel.swift
//  KISS Views
//

import Combine
import SwiftUI
import UIKit

/// A default AddAssetViewModel implementation for UIKit navigation.
final class UIKitRouterAddAssetViewModel: AddAssetViewModel {
    @Published var viewState = AddAssetViewState.loading
    @Published var searchPhrase = ""
    private(set) var selectedAssetsIds = [String]()

    private let assetsProvider: AssetsProvider
    private let favouriteAssetsManager: FavouriteAssetsManager
    private let router: UIKitNavigationRouter

    private var cancellables = Set<AnyCancellable>()
    private var allAssets = [Asset]()
    private var filteredAssets = [Asset]()

    /// A default initializer for AddAssetViewModel.
    ///
    /// - Parameter assetsProvider: an assets provider.
    /// - Parameter favouriteAssetsManager: a favourite assets manager.
    /// - Parameter router: a navigation router.
    init(
        assetsProvider: AssetsProvider,
        favouriteAssetsManager: FavouriteAssetsManager,
        router: UIKitNavigationRouter
    ) {
        self.assetsProvider = assetsProvider
        self.favouriteAssetsManager = favouriteAssetsManager
        self.router = router
        retrieveSelectedAssets()
        loadInitialAssets()
        setupAssetFiltering()
    }

    /// - SeeAlso: AddAssetViewModel.onAssetTapped(id:)
    func onAssetTapped(id: String) {
        if selectedAssetsIds.contains(id) {
            selectedAssetsIds.removeAll { $0 == id }
        } else {
            selectedAssetsIds.append(id)
        }
        composeViewState()
    }

    /// - SeeAlso: AddAssetViewModel.onAssetsSelectionConfirmed()
    func onAssetsSelectionConfirmed() {
        //  Discussion: We want to retain all the modifications users made to favourite assets...
        //  ... so we can't just replace the assets stored in the manager with the selected ones.
        let favouriteAssets = favouriteAssetsManager.retrieveFavouriteAssets()
        let favouriteAssetsIds = Set(favouriteAssets.map { $0.id })
        let selectedAssetsIds = Set(selectedAssetsIds)

        //  Combining assets to retain and to add in a single collection to store:
        let retainedAssetsIds = selectedAssetsIds.intersection(favouriteAssetsIds)
        let newAssetsIds = selectedAssetsIds.subtracting(retainedAssetsIds)
        let assetsToAdd = Set(allAssets.filter { newAssetsIds.contains($0.id) })
        let assetsToRetain = Set(favouriteAssets.filter { retainedAssetsIds.contains($0.id) })
        let assetsToStore = Array(assetsToRetain) + Array(assetsToAdd)

        favouriteAssetsManager.store(favouriteAssets: assetsToStore)
        router.stop() // TODO: Maybe navigateBack() instead?
    }

    /// - SeeAlso: AddAssetViewModel.onPopToRootTapped()
    func onPopToRootTapped() {
        router.switch(toRoute: MainAppRoute.assetsList, withData: nil)
    }
}

private extension UIKitRouterAddAssetViewModel {

    enum Const {
        static let searchLatency = 0.3
    }

    func loadInitialAssets() {
        Task { @MainActor [weak self] in
            let assets = await self?.assetsProvider.getAllAssets() ?? []
            self?.allAssets = assets
            self?.filteredAssets = assets.sorted {
                $0.id < $1.id
            }
            self?.composeViewState()
        }
    }

    func retrieveSelectedAssets() {
        selectedAssetsIds = favouriteAssetsManager
            .retrieveFavouriteAssets()
            .map {
                $0.id
            }
    }

    func setupAssetFiltering() {
        $searchPhrase
            .debounce(for: .seconds(Const.searchLatency), scheduler: RunLoop.main)
            .removeDuplicates()
            .dropFirst()
            .sink { [weak self] phrase in
                self?.filterAssets(phrase: phrase.lowercased())
                self?.composeViewState()
            }
            .store(in: &cancellables)
    }

    func filterAssets(phrase: String) {
        guard !phrase.isEmpty else {
            filteredAssets = allAssets
            return
        }

        filteredAssets = allAssets
            .filter { asset in
                asset.id.lowercased().contains(phrase) || asset.name.lowercased().contains(phrase)
            }
    }

    func composeViewState() {
        guard !allAssets.isEmpty else {
            viewState = .noAssets
            return
        }

        let cellData = filteredAssets
            .map {
                AssetCellView.Data(id: $0.id, title: $0.name, isSelected: selectedAssetsIds.contains($0.id))
            }
        viewState = .loaded(cellData)
    }
}

extension UIKitRouterAddAssetViewModel {
    var searchPhrasePublished: Published<String> { _searchPhrase }
    var searchPhrasePublisher: Published<String>.Publisher { $searchPhrase }
    var viewStatePublished: Published<AddAssetViewState> { _viewState }
    var viewStatePublisher: Published<AddAssetViewState>.Publisher { $viewState }
}
