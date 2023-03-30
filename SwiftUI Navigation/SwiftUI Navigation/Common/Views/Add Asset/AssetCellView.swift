//
//  AssetCellView.swift
//  KISS Views
//

import SwiftUI

struct AssetCellView: View {
    let data: AssetCellView.Data
    let onSelectTapped: ((String) -> Void)?

    var body: some View {
        ZStack {
            withAnimation {
                Color(data.isSelected ? .red : .clear)
            }
            Button(data.title) {
                onSelectTapped?(data.id)
            }
        }
    }
}

extension AssetCellView {

    struct Data: Hashable, Identifiable {
        let id: String
        let title: String
        let isSelected: Bool
    }
}

struct AssetCellView_Previews: PreviewProvider {
    static var previews: some View {
        AssetCellView(
            data: .init(id: "AU", title: "Gold", isSelected: false),
            onSelectTapped: nil
        )
        AssetCellView(
            data: .init(id: "AU", title: "Gold", isSelected: true),
            onSelectTapped: nil
        )
    }
}
