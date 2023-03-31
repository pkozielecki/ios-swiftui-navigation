//
//  FavouriteAssetCellView.swift
//  KISS Views
//

import SwiftUI

struct FavouriteAssetCellView: View {
    let data: FavouriteAssetCellView.Data
    let onSelectTapped: ((String) -> Void)?
    let onEditTapped: ((String) -> Void)?
    let onDeleteTapped: ((FavouriteAssetCellView.Data) -> Void)?

    var body: some View {
        Button(data.title) {
            onSelectTapped?(data.id)
        }
        .swipeActions {
            Button {
                onDeleteTapped?(data)
            } label: {
                Image(systemName: "trash")
            }
            .tint(.red)

            Button {
                onEditTapped?(data.id)
            } label: {
                Image(systemName: "pencil")
            }
            .tint(.green)
        }
    }
}

extension FavouriteAssetCellView {

    struct Data: Hashable {
        let id: String
        let title: String
    }
}

struct FavouriteAssetCellView_Previews: PreviewProvider {
    static var previews: some View {
        FavouriteAssetCellView(
            data: .init(id: "AU", title: "Gold"),
            onSelectTapped: nil,
            onEditTapped: nil,
            onDeleteTapped: nil
        )
    }
}
