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
    }

    func testBasicSetup() {}
}
