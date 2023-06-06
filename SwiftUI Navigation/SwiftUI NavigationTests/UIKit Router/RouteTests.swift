//
//  RouteTests.swift
//  KISS Views
//

import Foundation
import XCTest

@testable import SwiftUI_Navigation

final class RouteTest: XCTestCase {

    func testMainAppRoute() {
        verify(
            route: MainAppRoute.assetsList,
            expectedName: "MainAppRoute.AssetsList",
            expectedIsPopup: false,
            expectedPopupPresentationStyle: .none
        )
        verify(
            route: MainAppRoute.addAsset,
            expectedName: "MainAppRoute.AddAsset",
            expectedIsPopup: true,
            expectedPopupPresentationStyle: .modal
        )
        verify(
            route: MainAppRoute.appInfo,
            expectedName: "MainAppRoute.AppInfo",
            expectedIsPopup: true,
            expectedPopupPresentationStyle: .modal
        )

        // TODO: Add more tests for MainAppRoute cases (but is it really needed... ?)
    }
}

private extension RouteTest {

    func verify(route: any Route, expectedName: String, expectedIsPopup: Bool, expectedPopupPresentationStyle: PopupPresentationStyle) {
        XCTAssertEqual(route.name, expectedName, "\(route) should have proper name")
        XCTAssertEqual(route.isPopup, expectedIsPopup, "\(route) should have proper isPopup")
        XCTAssertEqual(route.popupPresentationStyle, expectedPopupPresentationStyle, "\(route) should have proper popup presentation style")
    }
}
