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
        sut.start()
    }

    func test_whenTryingToShowIncompatibleRoute_shouldDoNothing() {
        //  given:
        let fixtureIncompatibleRoute = EmptyRoute()

        //  when:
        sut.show(route: fixtureIncompatibleRoute)

        //  then:
        XCTAssertEqual(fakeNavigator.lastPushedViewController?.route.matches(fixtureIncompatibleRoute), false, "Should not show an incompatible route")
    }

    func test_whenStartingCoordinator_shouldPresentInitialViewOfTheFlow() {
        //  given:
        let expectedInitialRoute = MainAppRoute.assetsList
        let fixtureNavigationController = UINavigationController()
        fakeNavigator.simulatedNavigationStack = fixtureNavigationController

        //  then:
        XCTAssertEqual(fakeNavigator.lastPushedViewController?.route.matches(expectedInitialRoute), true, "Should show initial view of the flow")
        XCTAssert(sut.viewController === fixtureNavigationController, "Should use navigator's navigation stack as a view controller")
    }

    func test_settingAndGettingFlowCoordinatorRoute() {
        //  initially:
        XCTAssertEqual(sut.route.matches(EmptyRoute()), true, "Should return empty route when no route has been set")

        //  given:
        let fixtureRoute = MainAppRoute.appInfo

        //  when:
        sut.route = fixtureRoute

        //  then:
        XCTAssertEqual(sut.route.matches(fixtureRoute), true, "Should return route that has been set")
    }

    func test_handlingRoutesToShow() {
        XCTAssertEqual(sut.canShow(route: MainAppRoute.popupMainAppFlow), true, "Should handle any MainAppRoute")
        XCTAssertEqual(sut.canShow(route: MainAppRoute.assetsList), true, "Should handle any MainAppRoute")
        XCTAssertEqual(sut.canShow(route: AddAssetRoute.addAsset), false, "Should not handle any non-MainAppRoute")
    }

    func test_whenShowingTypicalUserPath_shouldRenderViewsInProperOrder() {
        //  given:
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

        //  then - should pop last view controller on the flow's navigation stack:
        XCTAssertEqual(fakeNavigator.lastPoppedToViewControllerAnimation, true, "Should pop last view controller")

        //  when:
        sut.navigateBackToRoot()

        //  then - should pop to root view controller on the flow's navigation stack:
        XCTAssertEqual(fakeNavigator.didPopToRootViewController, true, "Should pop to root view controller")
        XCTAssertEqual(fakeNavigator.lastPoppedToViewControllerAnimation, true, "Should pop to root view controller with animation")
    }

    func test_whenShowingRoutePresentableOnPopup_shouldShowViewOnPopup() {
        //  given:
        let fixturePopupRoute = MainAppRoute.appInfoStandalone

        //  when:
        sut.show(route: fixturePopupRoute)

        //  then - should show requested view as popup:
        XCTAssertEqual(fakeNavigator.lastPresentedViewController?.route.matches(fixturePopupRoute), true, "Should show requested view as popup")
        XCTAssertEqual(fakeNavigator.lastPresentedViewControllerAnimation, true, "Should show requested view as popup with animation")
        XCTAssertEqual(fakeNavigator.viewControllers.count, 1, "Should have 1 view controller on navigation stack")

        //  given:
        let fixturePopupRoute2 = MainAppRoute.appInfo

        //  when:
        sut.show(route: fixturePopupRoute2)

        //  then - should dismiss current popup and show new app flow on a newly opened popup:
        XCTAssertEqual(fakeNavigator.lastDismissedViewControllerAnimation, true, "Should dismiss current popup")
        XCTAssertEqual(sut.child?.route.matches(fixturePopupRoute2), true, "Should show requested view as flow on a popup")
    }

    func test_whenRestoringNavigation_shouldRenderMultipleViewsInProperOrder() {
        //  given:
        let fixtureRestoreNavigationRoute = MainAppRoute.restoreNavigation(assetId: fixtureAsset.id)

        //  when:
        sut.show(route: fixtureRestoreNavigationRoute)

        //  then - should create requested views (in order) and set in on flow's navigation stack:
        let expectedLastNavigationRoute = MainAppRoute.editAsset(assetId: fixtureAsset.id)
        let expectedMiddleNavigationRoute = MainAppRoute.assetDetails(assetId: fixtureAsset.id)
        XCTAssertEqual(fakeNavigator.viewControllers.count, 3, "Should restore navigation with 2 views")
        XCTAssertEqual(fakeNavigator.viewControllers.last?.route.matches(expectedLastNavigationRoute), true, "Should show last view")
        XCTAssertEqual(fakeNavigator.viewControllers[1].route.matches(expectedMiddleNavigationRoute), true, "Should show middle view")
    }

    func test_whenRestoringNavigationWithPopup_shouldRenderMultipleViewsInProperOrder() {
        //  given:
        let fixtureRestoreNavigationRoute = MainAppRoute.restorePopupNavigation

        //  when:
        sut.show(route: fixtureRestoreNavigationRoute)

        //  then - should create create a popup showing last view in the list:
        let expectedPopupRoute = MainAppRoute.appInfoStandalone
        XCTAssertEqual(fakeNavigator.viewControllers.count, 1, "Should not restore any views on the navigation stack")
        XCTAssertEqual(fakeNavigator.lastPresentedViewController?.route.matches(expectedPopupRoute), true, "Should show desired popup")
    }

    func test_whenRouteIsSeparateFlow_shouldCreateChildFlowAndStartIt() {
        verifyStartingAndStoppingChildFlow(route: .addAsset)
        verifyStartingAndStoppingChildFlow(route: .appInfo)
        verifyStartingAndStoppingChildFlow(route: .embeddedMainAppFlow)
        verifyStartingAndStoppingChildFlow(route: .popupMainAppFlow)
    }

    func test_whenSwitchToAlreadyDisplayedRouteIsRequested_shouldNavigateBackToDesiredRoute() {
        //  given:
        let fixtureAssetDetailsRoute = MainAppRoute.assetDetails(assetId: fixtureAsset.id)
        sut.show(route: fixtureAssetDetailsRoute)
        sut.show(route: MainAppRoute.editAsset(assetId: fixtureAsset.id))
        sut.show(route: MainAppRoute.addAsset)

        //  when:
        //  Current flow coordinator is now AddAssetFlowCoordinator, to we call `switch` on it - that's how the Router works.
        sut.child?.switch(toRoute: fixtureAssetDetailsRoute)

        //  then:
        XCTAssertNil(sut.child, "Should remove child flow")
        XCTAssertEqual(fakeNavigator.lastDismissedViewControllerAnimation, true, "Should dismiss a child flow on popup")
        XCTAssertEqual(fakeNavigator.viewControllers.count, 2, "Should have 2 view controllers")
        XCTAssertEqual(fakeNavigator.viewControllers.last?.route.matches(fixtureAssetDetailsRoute), true, "Should navigate back to desired route")
        XCTAssertEqual(fakeNavigator.lastPoppedToViewController?.route.matches(fixtureAssetDetailsRoute), true, "Should navigate back to desired route")
        XCTAssertEqual(fakeNavigator.lastPoppedToViewControllerAnimation, true, "Should navigate back to desired route animated")
    }

    func test_whenSwitchToNotYetDisplayedRouteIsRequested_shouldPopToProperCoordinator_andMakeItDisplayDesiredRoute() {
        //  given:
        let fixtureAssetDetailsRoute = MainAppRoute.assetDetails(assetId: fixtureAsset.id)
        sut.show(route: fixtureAssetDetailsRoute)
        sut.show(route: MainAppRoute.addAsset)

        //  when:
        //  Current flow coordinator is now AddAssetFlowCoordinator, to we call `switch` on it - that's how the Router works.
        let desiredRoute = MainAppRoute.editAsset(assetId: fixtureAsset.id)
        sut.child?.switch(toRoute: desiredRoute)

        //  then:
        XCTAssertNil(sut.child, "Should remove child flow")
        XCTAssertEqual(fakeNavigator.lastDismissedViewControllerAnimation, true, "Should dismiss a child flow on popup")
        XCTAssertEqual(fakeNavigator.viewControllers.count, 3, "Should have 3 view controllers")
        XCTAssertEqual(fakeNavigator.viewControllers.last?.route.matches(desiredRoute), true, "Should navigate back to Main flow and display desired route")
        XCTAssertNil(fakeNavigator.lastPoppedToViewController, "Should not navigate back on Main flow")
    }

    func test_whenDismissingManuallyFlowDisplayedOnPopup_shouldNotifyParentFlow() throws {
        //  given:
        sut.show(route: MainAppRoute.appInfo)

        //  when:
        let childFlowNavigator = fakeNavigator.lastPresentedViewController as? UINavigationController
        let childFlowNavigatorPresentationController = try XCTUnwrap(childFlowNavigator?.presentationController)
        childFlowNavigatorPresentationController.delegate?.presentationControllerDidDismiss?(childFlowNavigatorPresentationController)

        //  then:
        XCTAssertNil(sut.child, "Should remove child flow")
    }

    func test_whenRequestingNavigationBackToRoute_shouldCheckIfRouteIsShown() {
        //  given:
        sut.show(route: MainAppRoute.assetDetails(assetId: fixtureAsset.id))
        sut.show(route: MainAppRoute.appInfoStandalone)

        //  when - trying to go back to Route displayed as a popup:
        sut.navigateBack(toRoute: MainAppRoute.appInfoStandalone)

        //  then:
        XCTAssertNil(fakeNavigator.lastDismissedViewControllerAnimation, "Should not dismiss any view controller")
        XCTAssertNil(fakeNavigator.lastPoppedToViewController, "Should not pop to any view controller")

        //  when - trying to go back to Route not displayed at the moment:
        sut.navigateBack(toRoute: MainAppRoute.appInfo)

        //  then:
        XCTAssertNil(fakeNavigator.lastDismissedViewControllerAnimation, "Should not dismiss any view controller")
        XCTAssertNil(fakeNavigator.lastPoppedToViewController, "Should not pop to any view controller")

        //  when - truing to go back to Route displayed on the navigation stack:
        sut.navigateBack(toRoute: MainAppRoute.assetsList)

        //  then:
        XCTAssertEqual(fakeNavigator.lastDismissedViewControllerAnimation, true, "Should dismiss current popup")
        XCTAssertEqual(
            fakeNavigator.lastPoppedToViewController?.route.matches(MainAppRoute.assetsList),
            true,
            "Should pop to a view controller representing a desired route"
        )
    }

    func test_whenShowingPopupRoute_whenOtherPopupIsDisplayed_shouldHideThatPopupFirst() {
        //  given:
        sut.show(route: MainAppRoute.assetDetails(assetId: fixtureAsset.id))
        sut.show(route: MainAppRoute.appInfo)

        //  when:
        sut.show(route: MainAppRoute.appInfoStandalone)

        //  then:
        XCTAssertEqual(fakeNavigator.lastDismissedViewControllerAnimation, true, "Should dismiss current popup")
        XCTAssertEqual(fakeNavigator.lastPresentedViewController?.route.matches(MainAppRoute.appInfoStandalone), true, "Should show proper route")
    }
}

private extension MainAppFlowCoordinatorTest {

    var fixtureAsset: Asset {
        Asset(id: "XAU", name: "Gold", colorCode: nil)
    }

    func verifyStartingAndStoppingChildFlow(route: MainAppRoute) {
        //  when:
        sut.show(route: route)

        //  then:
        XCTAssertNotNil(sut.child, "Should create a child flow")

        //  when:
        sut.child?.stop()

        //  then:
        XCTAssertNil(sut.child, "Should remove child flow")
    }
}
