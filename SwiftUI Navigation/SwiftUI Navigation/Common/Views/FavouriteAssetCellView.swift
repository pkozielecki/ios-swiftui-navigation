//
//  FavouriteAssetCellView.swift
//  KISS Views
//

import SwiftUI

struct FavouriteAssetCellView: View {
    let data: FavouriteAssetCellView.Data
    let onSelectTapped: ((String) -> Void)?
    let onEditTapped: ((String) -> Void)?
    let onDeleteTapped: ((String) -> Void)?

    var body: some View {
        Button(action: {
            onSelectTapped?(data.id)
        }, label: {
            HStack {
                Text(data.id)
                    .padding(.leading, 20)
                    .frame(minWidth: 60)
                    .fontWeight(.bold)
                Text(data.title)
                    .lineLimit(1)
                Spacer()
                if let value = data.value {
                    Text(value)
                        .padding(.trailing, 20)
                        .fontWeight(.heavy)
                }
            }
            .background(Color("CellTappableBackground"))
        })
        .plain()
        .swipeActions {
            Button {
                onDeleteTapped?(data.id)
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

    struct Data: Identifiable, Hashable, Equatable {
        let id: String
        let title: String
        let value: String?
    }
}

struct FavouriteAssetCellView_Previews: PreviewProvider {
    static var previews: some View {
        FavouriteAssetCellView(
            data: .init(id: "AU", title: "Gold", value: "3.4"),
            onSelectTapped: nil,
            onEditTapped: nil,
            onDeleteTapped: nil
        )
    }
}
