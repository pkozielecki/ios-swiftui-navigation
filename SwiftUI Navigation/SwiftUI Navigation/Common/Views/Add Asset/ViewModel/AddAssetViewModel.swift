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

/// A default AddAssetViewModel implementation.
final class DefaultAddAssetViewModel: AddAssetViewModel {
    @Published var viewState = AddAssetViewState.loading
    @Published var searchPhrase = ""
    private(set) var selectedAssetsIds = [String]()

    private let assetsProvider: AssetsProvider
    private var cancellables = [AnyCancellable]()
    private var allAssets = [Asset]()
    private var filteredAssets = [Asset]()

    /// A default initializer for AddAssetViewModel.
    ///
    /// - Parameter assetsProvider: an assets provider.
    init(assetsProvider: AssetsProvider) {
        self.assetsProvider = assetsProvider
        loadInitialAssets()
        retrieveSelectedAssets()
        setupAssetFiltering()
        // TODO: Pass navigation router
    }

    func onAssetTapped(id: String) {
        if selectedAssetsIds.contains(id) {
            selectedAssetsIds.removeAll { $0 == id }
        } else {
            selectedAssetsIds.append(id)
        }
        composeViewState()
    }

    func onAssetsSelectionConfirmed() {
        print("----- SELECTED: \(selectedAssetsIds)")
        // TODO: Save selected assets and close the popup.
    }
}

private extension DefaultAddAssetViewModel {

    enum Const {
        static let searchLatency = 0.3
    }

    func loadInitialAssets() {
        Task { @MainActor [weak self] in
            let assets = await assetsProvider.getAllAssets()
            self?.allAssets = assets
            self?.filteredAssets = assets
            self?.composeViewState()
        }
    }

    func retrieveSelectedAssets() {
        // TODO: Get selected assets.
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
            .sorted {
                $0.id < $1.id
            }
            .map {
                AssetCellView.Data(id: $0.id, title: $0.name, isSelected: selectedAssetsIds.contains($0.id))
            }
        viewState = .loaded(cellData)
    }
}

extension DefaultAddAssetViewModel {
    var searchPhrasePublished: Published<String> { _searchPhrase }
    var searchPhrasePublisher: Published<String>.Publisher { $searchPhrase }
    var viewStatePublished: Published<AddAssetViewState> { _viewState }
    var viewStatePublisher: Published<AddAssetViewState>.Publisher { $viewState }
}
