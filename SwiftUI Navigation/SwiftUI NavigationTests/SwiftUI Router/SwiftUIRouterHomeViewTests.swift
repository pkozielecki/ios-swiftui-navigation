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
    var fakeNavigationRouter: FakeSwiftUINavigationRouter!
    var sut: SwiftUIRouterHomeView<FakeSwiftUIRouterHomeViewModel, FakeSwiftUINavigationRouter>!

    override func setUp() {
        fakeSwiftUIRouterHomeViewModel = FakeSwiftUIRouterHomeViewModel()
        fakeNavigationRouter = FakeSwiftUINavigationRouter()
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
        fakeNavigationRouter.set(navigationStack: [.assetDetails(fixtureId), .editAsset(fixtureId)])

        //  then:
        executeSnapshotTests(forView: sut, named: "SwiftUIRouterNavi_Home_PushedView")

        //  when:
        fakeNavigationRouter.set(navigationStack: [.assetDetails(fixtureId)])

        //  then:
        executeSnapshotTests(forView: sut, named: "SwiftUIRouterNavi_Home_PushedView_Popped")
    }

    func test_whenSettingPopup_shouldPresentProperView() throws {
        //  given:
        let vc = UIHostingController(rootView: sut)
        fakeNavigationRouter.presentedPopup = .appInfo

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
        fakeNavigationRouter.presentedAlert = .deleteAsset(assetId: "AU", assetName: "Gold")

        //  when:
        waitForDisplayListRedraw()
        let window = try XCTUnwrap(getAppKeyWindow(withRootViewController: vc), "Should have an access to app key window")
        waitForViewHierarchyRedraw(window: window)

        //  then:
        executeSnapshotTests(appWindow: window, named: "SwiftUIRouterNavi_Home_PresentedAlert")
    }
}
