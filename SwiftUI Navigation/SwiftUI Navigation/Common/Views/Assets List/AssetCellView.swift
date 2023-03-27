//
//  AssetCellView.swift
//  KISS Views
//

import SwiftUI

struct AssetCellView: View {
    let data: AssetCellView.Data
    let onSelectTapped: ((String) -> Void)?
    let onEditTapped: ((String) -> Void)?
    let onDeleteTapped: ((String) -> Void)?

    var body: some View {
        Button(data.title) {
            onSelectTapped?(data.id)
        }
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

extension AssetCellView {

    struct Data: Hashable {
        let id: String
        let title: String
    }
}

struct AssetCellView_Previews: PreviewProvider {
    static var previews: some View {
        AssetCellView(
            data: .init(id: "AU", title: "Gold"),
            onSelectTapped: nil,
            onEditTapped: nil,
            onDeleteTapped: nil
        )
    }
}
