//
//  EditAssetViewData.swift
//  KISS Views
//

import SwiftUI

/// A structure representing an edited asset properties.
struct EditAssetViewData: Hashable, Identifiable {
    /// An asset id.
    let id: String

    /// An asset name.
    let name: String

    /// An asset position on the assets list.
    let position: Position

    /// An asset color.
    let color: Color
}

extension EditAssetViewData {

    /// An helper structure representing asset position on favourite assets list.
    struct Position: Hashable {
        let currentPosition: Int
        let numElements: Int
    }

    /// A convenience initializer for EditViewAssetData.
    ///
    /// - Parameters:
    ///   - asset: an asset to use as a base.
    ///   - position: an asset position in favourite assets list.
    ///   - totalAssetCount: a total number of assets.
    init(asset: Asset, position: Int, totalAssetCount: Int) {
        self.init(
            id: asset.id,
            name: asset.name,
            position: .init(currentPosition: position + 1, numElements: totalAssetCount),
            color: asset.color
        )
    }
}

extension EditAssetViewData.Position: Identifiable {

    /// An identifiable property of an asset.
    var id: String {
        "\(currentPosition)\(numElements)"
    }
}
