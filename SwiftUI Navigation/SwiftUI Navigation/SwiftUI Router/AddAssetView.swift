//
//  AddAssetView.swift
//  KISS Views
//

import SwiftUI

struct AddAssetView<ViewModel>: View where ViewModel: AddAssetViewModel {
    @StateObject var viewModel: ViewModel

    var body: some View {
        ZStack {
            if showPreloader {
                LoaderView(configuration: .default)
            } else if hasAssets {
                VStack(alignment: .center) {
                    List {

                        //  A search bar section:
                        SwiftUISearchBar(text: $viewModel.searchPhrase)

                        //  An assets section:
                        Section("Assets:") {
                            ForEach(assetCellsData) { data in
                                AssetCellView(data: data) { _ in
                                    viewModel.onAssetTapped(id: data.id)
                                }
                                .noInsetsCell()
                            }
                            if !hasFilteredAssets {
                                Text("Couldn't find any assets matching the search criteria")
                            }
                        }

                        //  A footer with add assets button:
                        PrimaryButton(label: "Add selected \(formattedSelectedAssetsCount)asset(s) to ❤️") {
                            viewModel.onAssetsSelectionConfirmed()
                        }
                        .disabled(viewModel.selectedAssetsIds.isEmpty)
                    }
                    .listStyle(.grouped)
                }
            } else {
                Spacer()
                Text("No assets to show")
                Spacer()
            }
        }
    }
}

private extension AddAssetView {

    var selectedAssetsCount: Int {
        viewModel.selectedAssetsIds.count
    }

    var formattedSelectedAssetsCount: String {
        selectedAssetsCount == 0 ? "" : "\(selectedAssetsCount) "
    }

    var assetCellsData: [AssetCellView.Data] {
        if case let .loaded(assets) = viewModel.viewState {
            return assets
        }
        return []
    }

    var hasAssets: Bool {
        if case .noAssets = viewModel.viewState {
            return false
        }
        return true
    }

    var hasFilteredAssets: Bool {
        !assetCellsData.isEmpty
    }

    var showPreloader: Bool {
        if case .loading = viewModel.viewState {
            return true
        }
        return false
    }
}

struct AddAssetView_Previews: PreviewProvider {
    static var previews: some View {
//        let viewState = AddAssetViewState.loading
//        let viewState = AddAssetViewState.noAssets
        let viewState = AddAssetViewState.loaded([
            AssetCellView.Data(id: "Au", title: "Gold", isSelected: false),
            AssetCellView.Data(id: "Ag", title: "Silver", isSelected: true)
        ])
        let viewModel = PreviewAddAssetViewModel(state: viewState)
        return AddAssetView(viewModel: viewModel)
    }
}
