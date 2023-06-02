//
//  MainAppFlowCoordinatorTests.swift
//  KISS Views
//

import Foundation
import XCTest

@testable import SwiftUI_Navigation

final class MainAppFlowCoordinatorTest: XCTestCase {
    var fakeNavigator: FakeNavigator!
    var fakeDependencyProvider: FakeDependencyProvider!
    var sut: MainAppFlowCoordinator!

    override func setUp() {
        fakeNavigator = FakeNavigator()
        fakeDependencyProvider = FakeDependencyProvider()
        sut = MainAppFlowCoordinator(
            navigator: fakeNavigator,
            dependencyProvider: fakeDependencyProvider,
            parent: nil
        )
        sut.start(animated: false)
    }

    // TODO: Add show, switch, navigateBack, navigateBackToRoot, etc. tests

    func test_whenStartingCoordinator_shouldPresentInitialViewOfTheFlow() {
        //  given:
        let expectedInitialRoute = MainAppRoute.assetsList

        //  then:
        XCTAssertEqual(fakeNavigator.lastPushedViewController?.route.matches(expectedInitialRoute), true, "Should show initial view of the flow")
    }

    func test_handlingRoutesToShow() {
        XCTAssertEqual(sut.canShow(route: MainAppRoute.popupMainAppFlow), true, "Should handle any MainAppRoute")
        XCTAssertEqual(sut.canShow(route: MainAppRoute.assetsList), true, "Should handle any MainAppRoute")
        XCTAssertEqual(sut.canShow(route: AddAssetRoute.addAsset), false, "Should not handle any non-MainAppRoute")
    }

    func test_whenShowingTypicalUserPath_shouldRenderViewsInProperOrder() {
        //  given:
        let fixtureAsset = Asset(id: "XAU", name: "Gold", colorCode: nil)
        let fixtureAssetDetailsRoute = MainAppRoute.assetDetails(assetId: fixtureAsset.id)

        //  when:
        sut.show(route: fixtureAssetDetailsRoute)

        //  then:
        XCTAssertEqual(fakeNavigator.lastPushedViewController?.route.matches(fixtureAssetDetailsRoute), true, "Should show requested view")

        //  given:
        let fixtureEditAssetRoute = MainAppRoute.editAsset(assetId: fixtureAsset.id)

        //  when:
        sut.show(route: fixtureEditAssetRoute)

        //  then:
        XCTAssertEqual(fakeNavigator.lastPushedViewController?.route.matches(fixtureEditAssetRoute), true, "Should show requested view")

        //  when:
        sut.navigateBack()

        //  then:
        XCTAssertEqual(fakeNavigator.lastPoppedViewControllerAnimation, true, "Should pop last view controller")

        //  when:
        sut.navigateBackToRoot()

        //  then:
        XCTAssertEqual(fakeNavigator.didPopToRootViewController, true, "Should pop to root view controller")
        XCTAssertEqual(fakeNavigator.lastPoppedViewControllerAnimation, true, "Should pop to root view controller with animation")

        // TODO: presenting a route as a popup
    }

    func test_whenRestoringNavigation_shouldRenderMultipleViewsInProperOrder() {
        //  given:
        let fixtureAsset = Asset(id: "XAU", name: "Gold", colorCode: nil)
        let fixtureRestoreNavigationRoute = MainAppRoute.restoreNavigation(assetId: fixtureAsset.id)

        //  when:
        sut.show(route: fixtureRestoreNavigationRoute)

        //  then:
        let expectedLastNavigationRoute = MainAppRoute.editAsset(assetId: fixtureAsset.id)
        let expectedMiddleNavigationRoute = MainAppRoute.assetDetails(assetId: fixtureAsset.id)
        XCTAssertEqual(fakeNavigator.viewControllers.count, 3, "Should restore navigation with 2 views")
        XCTAssertEqual(fakeNavigator.viewControllers.last?.route.matches(expectedLastNavigationRoute), true, "Should show last view")
        XCTAssertEqual(fakeNavigator.viewControllers[1].route.matches(expectedMiddleNavigationRoute), true, "Should show middle view")
    }
}
