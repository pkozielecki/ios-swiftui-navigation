//
//  SwiftUIRouterHomeViewTests.swift
//  KISS Views
//

import SnapshotTesting
import SwiftUI
import UIKit
import XCTest

@testable import SwiftUI_Navigation

final class SwiftUIRouterHomeViewTest: XCTestCase {
    var fakeSwiftUIRouterHomeViewModel: FakeSwiftUIRouterHomeViewModel!
    var fakeNavigationRouter: FakeNavigationRouter!
    var sut: SwiftUIRouterHomeView<FakeSwiftUIRouterHomeViewModel, FakeNavigationRouter>!

    override func setUp() {
        fakeSwiftUIRouterHomeViewModel = FakeSwiftUIRouterHomeViewModel()
        fakeNavigationRouter = FakeNavigationRouter()
        sut = SwiftUIRouterHomeView(viewModel: fakeSwiftUIRouterHomeViewModel, router: fakeNavigationRouter)
    }

    func test_whenInitialized_shouldShowStartView() {
        executeSnapshotTests(forView: sut, named: "SwiftUIRouterNavi_Home_InitialView")
    }

    func test_whenNavigationStackIsSet_shouldPushProperView() {
        //  given:
        let fixtureId = "AU"
        let fixtureAsset = Asset(id: fixtureId, name: "Gold", colorCode: nil)
        let fixtureAsset2 = Asset(id: "BTC", name: "Bitcoin", colorCode: nil)
        fakeSwiftUIRouterHomeViewModel.fakeFavouriteAssetsManager.simulatedFavouriteAssets = [fixtureAsset, fixtureAsset2]

        //  when:
        fakeNavigationRouter.set(navigationStack: [
            .makeScreen(named: .assetDetails(fixtureId)),
            .makeScreen(named: .editAsset(fixtureId))
        ])

        //  then:
        executeSnapshotTests(forView: sut, named: "SwiftUIRouterNavi_Home_PushedView")
    }

    func test_whenSettingPopup_shouldPresentProperView() throws {
        //  given:
        let vc = UIHostingController(rootView: sut)
        fakeNavigationRouter.presentedPopup = .makePopup(named: .appInfo)

        //  when:
        waitForDisplayListRedraw()
        let window = try XCTUnwrap(getAppKeyWindow(withRootViewController: vc), "Should have an access to app key window")
        waitForViewHierarchyRedraw(window: window)

        //  then:
        executeSnapshotTests(appWindow: window, named: "SwiftUIRouterNavi_Home_PresentedView")
    }

    func test_whenSettingAlert_shouldPresentProperAlert() throws {
        //  given:
        let vc = UIHostingController(rootView: sut)
        fakeNavigationRouter.presentedAlert = .makeAlert(named: .deleteAsset(assetId: "AU", assetName: "Gold"))

        //  when:
        waitForDisplayListRedraw()
        let window = try XCTUnwrap(getAppKeyWindow(withRootViewController: vc), "Should have an access to app key window")
        waitForViewHierarchyRedraw(window: window)

        //  then:
        executeSnapshotTests(appWindow: window, named: "SwiftUIRouterNavi_Home_PresentedAlert")
    }
}
