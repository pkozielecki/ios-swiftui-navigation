//
//  NavigationRouterTests.swift
//  KISS Views
//

import Foundation
import XCTest

import Foundation
import XCTest

@testable import SwiftUI_Navigation

final class DefaultNavigationRouterTest: XCTestCase {
    var sut: DefaultSwiftUINavigationRouter!

    override func setUp() {
        sut = DefaultSwiftUINavigationRouter()
    }

    func test_whenInitialisingNavigationStack_itShouldStartEmpty() {
        XCTAssertEqual(sut.navigationStack.count, 0, "Should start w empty navigation stack")
        XCTAssertEqual(sut.presentedPopup, nil, "Should start with no presented popup")
        XCTAssertEqual(sut.navigationRoute, nil, "Should start with no presented route")
        XCTAssertEqual(sut.presentedAlert, nil, "Should start with no presented alert")
    }

    func test_whenPushingAndPoppingViews_shouldUpdateNavigationStack() {
        //  given:
        let fixtureFirstScreen = NavigationRoute.editAsset("abc")
        let fixtureSecondScreen = NavigationRoute.editAsset("efg")

        //  when:
        sut.push(route: fixtureFirstScreen)
        sut.push(route: fixtureSecondScreen)

        //  then:
        XCTAssertEqual(sut.navigationRoute, fixtureSecondScreen, "Should be showing proper screen")
        XCTAssertEqual(sut.navigationStack.count, 2, "Should update navigation stack")

        //  when:
        sut.pop()

        //  then:
        XCTAssertEqual(sut.navigationRoute, fixtureFirstScreen, "Should pop the screen from navigation stack")
    }

    func test_whenPresentingAndDismissingPopup_shouldNotifySubscribers() {
        //  given:
        let fixtureFirstPopup = PopupRoute.addAsset

        //  when:
        sut.present(popup: fixtureFirstPopup)

        //  then:
        XCTAssertEqual(sut.presentedPopup, fixtureFirstPopup, "Should be showing second popup")

        //  given:
        let fixtureSecondPopup = PopupRoute.homeView

        //  when:
        sut.present(popup: fixtureSecondPopup)

        //  then:
        XCTAssertEqual(sut.presentedPopup, fixtureSecondPopup, "Should be showing second popup")

        //  when:
        sut.dismiss()

        //  then:
        XCTAssertEqual(sut.presentedPopup, nil, "Should be dismiss the popup")
    }

    func test_whenShowingAndHiding_shouldNotifySubscribers() {
        //  given:
        let fixtureAlert = AlertRoute.deleteAsset(assetId: "abc", assetName: "ABC")

        //  when:
        sut.show(alert: fixtureAlert)

        //  then:
        XCTAssertEqual(sut.presentedAlert, fixtureAlert, "Should be showing an alert")

        //  when:
        sut.hideCurrentAlert()

        //  then:
        XCTAssertEqual(sut.presentedAlert, nil, "Should hide current alert")
    }

    func test_whenSettingNavigationStack_shouldReplaceCurrentlyDisplayedScreens() {
        //  given:
        let fixtureFirstScreen = NavigationRoute.assetDetails("abc")
        let fixtureSecondScreen = NavigationRoute.editAsset("xyz")
        sut.push(route: fixtureFirstScreen)

        //  when:
        sut.set(navigationStack: [fixtureSecondScreen])

        //  then:
        XCTAssertEqual(sut.navigationRoute, fixtureSecondScreen, "Should set navigation stack accordingly")
        XCTAssertEqual(sut.navigationStack.count, 1, "Should replace all previous screens in navigation stack")
    }

    func test_whenPoppingAllScreens_shouldClearNavigationStack() {
        //  given:
        let fixtureFirstScreen = NavigationRoute.assetDetails("abc")
        let fixtureSecondScreen = NavigationRoute.editAsset("xyz")
        sut.push(route: fixtureFirstScreen)
        sut.push(route: fixtureFirstScreen)
        sut.push(route: fixtureSecondScreen)
        sut.push(route: fixtureSecondScreen)
        sut.push(route: fixtureSecondScreen) // Testing if we can add multiple instances of the same view.

        //  then:
        XCTAssertEqual(sut.navigationStack.count, 5, "Should show all the added views")

        //  when:
        sut.popAll()

        //  then:
        XCTAssertEqual(sut.navigationRoute, nil, "Should show no screen")
        XCTAssertEqual(sut.navigationStack.count, 0, "Should pop all screens from nav stack")
    }

    func test_whenSettingNavigationStack_shouldShowWholeCollectionOfViews() {
        //  given:
        let fixtureFirstScreen = NavigationRoute.assetDetails("abc")
        let fixtureSecondScreen = NavigationRoute.editAsset("xyz")
        sut.set(navigationStack: [fixtureFirstScreen, fixtureSecondScreen])

        //  when:
        sut.pop()

        //  then:
        XCTAssertEqual(sut.navigationRoute, fixtureFirstScreen, "Should show first app screen")
        XCTAssertEqual(sut.navigationStack.count, 1, "Should have only one screen on the stack")
    }
}
