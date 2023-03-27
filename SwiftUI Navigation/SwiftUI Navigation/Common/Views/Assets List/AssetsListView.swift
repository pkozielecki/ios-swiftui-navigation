//
//  AssetsListView.swift
//  KISS Views
//

import SwiftUI

struct AssetsListView<Router: NavigationRouter>: View {
    @ObservedObject var router: Router

    var body: some View {
        List {
            Section(header:
                HStack(alignment: .center) {
                    Text("Your asssets")
                    Spacer()
                    Button {
                        addNewTapped()
                    } label: {
                        Image(systemName: "plus.circle.fill")
                    }
                    .padding(.top, 10)
                    .padding(.bottom, 10)
                }
            ) {
                AssetCellView(
                    data: .init(id: "AU", title: "Gold"),
                    onSelectTapped: onAssetSelected,
                    onEditTapped: onEditAssetSelected,
                    onDeleteTapped: onAssetRemovalRequest
                )
                Text("Silver")
                Text("BTC")
            }
        }
    }
}

private extension AssetsListView {

    func addNewTapped() {
        router.present(popup: .addAsset)
    }

    func onAssetSelected(id: String) {
        router.push(screen: .assetCharts(id))
    }

    func onEditAssetSelected(id: String) {
        router.push(screen: .editAsset(id))
    }

    func onAssetRemovalRequest(id: String) {
        // TODO: Show configuration alert on router
        print("Asset selected for removal: \(id)")
    }
}

struct AssetsListView_Previews: PreviewProvider {
    static var previews: some View {
        AssetsListView(router: PreviewNavigationRouter())
    }
}
