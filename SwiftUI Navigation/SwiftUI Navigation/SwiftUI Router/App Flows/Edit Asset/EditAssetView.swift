//
//  EditAssetView.swift
//  KISS Views
//

import SwiftUI

struct EditAssetView<ViewModel>: View where ViewModel: EditAssetViewModel {
    @StateObject var viewModel: ViewModel

    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            Text("EditAssetView \(viewModel.assetId)")
            Button("Go back to root", action: viewModel.popToRoot)
            Spacer()
        }
    }
}

private extension EditAssetView {}

struct EditAssetView_Previews: PreviewProvider {
    static var previews: some View {
        let viewState = EditAssetViewState.loading
        let viewModel = PreviewEditAssetViewModel(state: viewState)
        return EditAssetView(viewModel: viewModel)
    }
}
