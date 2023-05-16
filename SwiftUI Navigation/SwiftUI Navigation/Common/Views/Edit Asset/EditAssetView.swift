//
//  EditAssetView.swift
//  KISS Views
//

import Combine
import SwiftUI

struct EditAssetView<ViewModel>: View where ViewModel: EditAssetViewModel {
    @StateObject var viewModel: ViewModel

    @State private var assetName: String?
    @State private var assetColor: Color?
    @State private var assetPosition: Int?

    var body: some View {

        if let assetData {

            VStack(alignment: .center, spacing: 30) {

                Spacer()

                Text("Editing: \(assetData.id)")
                    .viewTitle()

                Text("Change asset name, position and color")
                    .viewDescription()

                Divider()
                    .padding(.vertical, 30)

                HStack {
                    Text("Asset name:")
                    TextField(text: .init(currentValue: $assetName, initialValue: assetData.name), label: {
                        Text("Enter asset name")
                    })
                    .textFieldStyle(.roundedBorder)
                }

                ColorPicker(selection: .init(currentValue: $assetColor, initialValue: assetData.color), supportsOpacity: false) {
                    Text("Choose asset color:")
                }

                VStack(alignment: .leading) {
                    Text("Choose asset position:")
                    Picker("", selection: .init(currentValue: $assetPosition, initialValue: assetData.position.currentPosition)) {
                        ForEach(1...assetData.position.numElements, id: \.self) { position in
                            Text("\(position)")
                        }
                    }
                    .pickerStyle(.segmented)
                }

                Spacer()

                //  A footer with add assets button:
                PrimaryButton(label: "Save changes") {
                    if let updatedAssetData {
                        viewModel.saveChanges(assetData: updatedAssetData)
                    }
                }
                .disabled(!isChanged)

            }.padding(20)

        } else {
            VStack(alignment: .center, spacing: 30) {
                Spacer()
                Text("Asset not found")
                Spacer()
            }
        }
    }
}

private extension EditAssetView {

    var isChanged: Bool {
        assetName != nil || assetColor != nil || assetPosition != nil
    }

    var assetData: EditAssetViewData? {
        if case let .editAsset(data) = viewModel.viewState {
            return data
        }
        return nil
    }

    var notFound: Bool {
        if case .assetNotFound = viewModel.viewState {
            return true
        }
        return false
    }

    var updatedAssetData: EditAssetViewData? {
        guard let assetData else { return nil }

        let position = assetPosition ?? assetData.position.currentPosition
        return EditAssetViewData(
            id: assetData.id,
            name: assetName ?? assetData.name,
            position: .init(currentPosition: position, numElements: assetData.position.numElements),
            color: assetColor ?? assetData.color
        )
    }
}

struct EditAssetView_Previews: PreviewProvider {
    static var previews: some View {
//        let viewState = EditAssetViewState.assetNotFound
        let viewState = EditAssetViewState.editAsset(.init(id: "AU", name: "Gold", position: .init(currentPosition: 2, numElements: 5), color: .white))
        let viewModel = PreviewEditAssetViewModel(state: viewState)
        return EditAssetView(viewModel: viewModel)
    }
}
