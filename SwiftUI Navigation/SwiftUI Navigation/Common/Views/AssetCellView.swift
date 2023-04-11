//
//  AssetCellView.swift
//  KISS Views
//

import SwiftUI

struct AssetCellView: View {
    let data: AssetCellView.Data
    let onSelectTapped: ((String) -> Void)?

    var body: some View {
        ZStack(alignment: .leading) {

            Color(data.isSelected ? .lightGray : .clear)
                .animation(.easeInOut(duration: 0.2), value: data.isSelected)

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
                }
                .background(.secondary.opacity(0.0001))
            })
            .plain()
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
        ).frame(width: .infinity, height: 50)
        AssetCellView(
            data: .init(id: "AU", title: "Gold", isSelected: true),
            onSelectTapped: nil
        )
        .frame(width: .infinity, height: 50)
    }
}
