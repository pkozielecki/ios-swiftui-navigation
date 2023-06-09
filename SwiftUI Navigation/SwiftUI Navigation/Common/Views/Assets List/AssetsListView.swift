//
//  AssetsListView.swift
//  KISS Views
//

import SwiftUI

struct AssetsListView<ViewModel: AssetsListViewModel>: View {
    @StateObject var viewModel: ViewModel

    var body: some View {
        ZStack {
            if hasNoAssets {
                VStack(spacing: 30) {
                    Spacer()

                    Text("No favourite assets")
                        .viewTitle()

                    Text("Select your favourite assets to check their exchange rates!")
                        .viewDescription()

                    Spacer()

                    PrimaryButton(
                        label: "Select favourite assets",
                        onTapCallback: viewModel.onAddNewAssetTapped
                    )
                }
                .padding(20)
            } else {
                List {
                    Section(header:
                        HStack(alignment: .center) {
                            Text("Your asssets")
                            Spacer()
                            Button {
                                viewModel.onAppInfoTapped()
                            } label: {
                                Image(systemName: "info.circle.fill")
                            }
                            Button {
                                viewModel.onAddNewAssetTapped()
                            } label: {
                                Image(systemName: "plus.circle.fill")
                            }
                            .padding(.top, 10)
                            .padding(.bottom, 10)
                        }, footer:
                        Text("Last updated: \(lastUpdated)")
                    ) {
                        ForEach(assets) { data in
                            FavouriteAssetCellView(
                                data: data,
                                onSelectTapped: onAssetSelected,
                                onEditTapped: onEditAssetSelected,
                                onDeleteTapped: onAssetRemovalRequest
                            )
                            .noInsetsCell()
                        }
                    }
                }
                .navigationTitle("Assets list")
                .refreshable {
                    viewModel.onRefreshRequested()
                }
            }
        }
    }
}

private extension AssetsListView {

    var hasNoAssets: Bool {
        if case .noFavouriteAssets = viewModel.viewState {
            return true
        }
        return false
    }

    var assets: [FavouriteAssetCellView.Data] {
        switch viewModel.viewState {
        case let .loaded(assets, _), let .loading(assets):
            return assets
        default:
            return []
        }
    }

    var lastUpdated: String {
        switch viewModel.viewState {
        case let .loaded(_, date):
            return date
        default:
            return ""
        }
    }

    func onAssetSelected(id: String) {
        viewModel.onAssetSelected(id: id)
    }

    func onEditAssetSelected(id: String) {
        viewModel.onAssetSelectedToBeEdited(id: id)
    }

    func onAssetRemovalRequest(id: String) {
        viewModel.onAssetSelectedForRemoval(id: id)
    }
}

struct AssetsListView_Previews: PreviewProvider {
    static var previews: some View {
//        let state = AssetsListViewState.noFavouriteAssets
//        let state = AssetsListViewState.loading([.init(id: "EUR", title: "Euro", value: nil), .init(id: "BTC", title: "Bitcoin", value: nil)])
        let state = AssetsListViewState.loaded([.init(id: "EUR", title: "Euro", color: .primary, value: "1.2"), .init(id: "BTC", title: "Bitcoin", color: .primary, value: "28872")], "2023-05-10 12:30:12")
        AssetsListView(viewModel: PreviewAssetsListViewModel(state: state))
    }
}
