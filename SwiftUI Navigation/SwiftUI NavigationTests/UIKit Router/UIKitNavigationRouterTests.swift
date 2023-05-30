//
//  UIKitNavigationRouterTests.swift
//  KISS Views
//

import SwiftUI
import UIKit
import XCTest

@testable import SwiftUI_Navigation

final class UIKitNavigationRouterTest: XCTestCase {
    var fakeInitialFlowCoordinator: FakeFlowCoordinator!
    var sut: DefaultUIKitNavigationRouter!

    override func setUp() {
        fakeInitialFlowCoordinator = FakeFlowCoordinator()
        sut = DefaultUIKitNavigationRouter()
        sut.start(initialFlow: fakeInitialFlowCoordinator, animated: false)
    }

    func test_initialFlowSetup() {
        XCTAssertEqual(sut.currentFlow === fakeInitialFlowCoordinator, true, "Should start a provided initial flow")
    }

    func test_whenShowingRoute_shouldForwardCallToCurrentFlowCoordinator() {
        //  given:
        let fixtureRoute = MainAppRoute.editAsset(assetId: "")
        let fixtureData = "fixtureData"

        //  when:
        sut.show(route: fixtureRoute, withData: fixtureData)

        //  then:
        XCTAssertNil(currentFlow?.lastShownRoute, "When route is not supported by current flow, it should not be executed")

        //  given:
        fakeInitialFlowCoordinator.simulatedCanShow = true

        //  when:
        sut.show(route: fixtureRoute, withData: fixtureData)

        //  then:
        XCTAssertEqual(currentFlow?.lastShownRoute?.matches(fixtureRoute), true, "Should execute desired route on current flow")
        XCTAssertEqual(currentFlow?.lastShownRouteData, fixtureData, "Should pass proper data to current flow")
    }

    func test_whenSwitchingToRoute_shouldForwardCallToCurrentFlowCoordinator() {
        //  given:
        let fixtureRoute = MainAppRoute.addAsset
        let fixtureData = "fixtureData2"

        //  when:
        sut.switch(toRoute: fixtureRoute, withData: fixtureData)

        //  then:
        XCTAssertEqual(currentFlow?.lastSwitchedToRoute?.matches(fixtureRoute), true, "Should switch to a desired route on current flow")
        XCTAssertEqual(currentFlow?.lastSwitchedToRouteData, fixtureData, "Should pass proper data to current flow")
    }
}

extension UIKitNavigationRouterTest {

    var currentFlow: FakeFlowCoordinator? {
        sut.currentFlow as? FakeFlowCoordinator
    }
}
