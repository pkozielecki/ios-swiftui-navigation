//
//  FakeAssetsProvider.swift
//  KISS Views
//

import Foundation

@testable import SwiftUI_Navigation

final actor FakeAssetsProvider: AssetsProvider {
    var simulatedAssets: [Asset]?

    func getAllAssets() async -> [Asset] {
        simulatedAssets ?? []
    }
}
