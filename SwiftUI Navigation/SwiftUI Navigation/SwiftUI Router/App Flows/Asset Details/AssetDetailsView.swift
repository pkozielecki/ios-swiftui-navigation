//
//  AssetDetailsView.swift
//  KISS Views
//

import SwiftUI

struct AssetDetailsView<ViewModel>: View where ViewModel: AssetDetailsViewModel {
    @StateObject var viewModel: ViewModel

    var body: some View {
        ZStack {
            Text("EditAssetView \(viewModel.assetId)")
        }
    }
}

private extension AssetDetailsView {}

struct AssetDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        let viewState = AssetDetailsViewState.loading
        let viewModel = PreviewAssetDetailsViewModel(state: viewState)
        return AssetDetailsView(viewModel: viewModel)
    }
}
