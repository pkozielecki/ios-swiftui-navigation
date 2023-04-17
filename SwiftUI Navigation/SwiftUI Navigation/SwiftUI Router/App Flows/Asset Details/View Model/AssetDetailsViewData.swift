//
//  AssetDetailsViewData.swift
//  KISS Views
//

import Foundation

/// A structure describing data shown by Asset Details View.
struct AssetDetailsViewData: Identifiable, Hashable {

    /// An asset id.
    let id: String

    /// An asset name.
    let name: String
}

extension AssetDetailsViewData {

    /// An empty asset data:
    static var empty: AssetDetailsViewData {
        .init(id: "", name: "Unknown asset")
    }
}

extension Asset {

    /// A convenience method converting an asset into AssetDetailsViewData.
    func toAssetDetailsViewData() -> AssetDetailsViewData {
        AssetDetailsViewData(id: id, name: name)
    }
}
