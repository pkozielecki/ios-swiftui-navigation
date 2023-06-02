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

    func test_startingInitialFlow() {
        XCTAssertEqual(fakeInitialFlowCoordinator.lastDidStartAnimated, false, "Should start initial flow without animation")
    }

    func test_calculatingCurrentFlow() {
        //  initially:
        XCTAssertEqual(sut.currentFlow === fakeInitialFlowCoordinator, true, "Should start a provided initial flow")

        //  when:
        let fakeChildFlowCoordinator = FakeFlowCoordinator()
        let fakeChildFlowCoordinator2 = FakeFlowCoordinator()
        fakeChildFlowCoordinator.child = fakeChildFlowCoordinator2
        currentFlow?.child = fakeChildFlowCoordinator

        //  then:
        XCTAssertEqual(sut.currentFlow === fakeChildFlowCoordinator2, true, "Should always return the last child flow coordinator as a current flow")
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

    func test_whenNavigatingBack_shouldForwardCallToCurrentFlowCoordinator() {
        //  given:
        let fixtureAnimated = false

        //  when:
        sut.navigateBack(animated: fixtureAnimated)

        //  then:
        XCTAssertEqual(currentFlow?.lastNavigatedBackAnimated, fixtureAnimated, "Should navigate back on current flow")
    }

    func test_whenNavigatingBackToRoot_shouldForwardCallToCurrentFlowCoordinator() {
        //  given:
        let fixtureAnimated = false

        //  when:
        sut.navigateBackToRoot(animated: fixtureAnimated)

        //  then:
        XCTAssertEqual(currentFlow?.lastNavigatedBackToRootAnimated, fixtureAnimated, "Should navigate back to root on current flow")
    }

    func test_whenNavigatingBackToParticularRoute_shouldForwardCallToCurrentFlowCoordinator() {
        //  given:
        let fixtureAnimated = false
        let fixtureRoute = MainAppRoute.addAsset

        //  when:
        sut.navigateBack(toRoute: fixtureRoute, animated: fixtureAnimated)

        //  then:
        XCTAssertEqual(currentFlow?.lastNavigatedBackToRoute?.matches(fixtureRoute), true, "Should navigate back to route on current flow")
        XCTAssertEqual(currentFlow?.lastNavigatedBackToRouteAnimated, fixtureAnimated, "Should navigate back to route on current flow ")
    }

    func test_whenRequestingStoppingFlow_shouldForwardCallToCurrentFlowCoordinator() {
        //  when:
        sut.stopCurrentFlow()

        //  then:
        XCTAssertEqual(currentFlow?.lastDidStop, true, "Should stop current flow")
    }
}

extension UIKitNavigationRouterTest {

    var currentFlow: FakeFlowCoordinator? {
        sut.currentFlow as? FakeFlowCoordinator
    }
}
