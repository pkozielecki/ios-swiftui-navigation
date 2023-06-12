//
//  DefaultAlertPresenterTests.swift
//  KISS Views
//

import UIKit
import XCTest

@testable import SwiftUI_Navigation

final class DefaultAlertPresenterTest: XCTestCase {
    var fakeNavigationController: FakeUINavigationController!
    var sut: DefaultAlertPresenter!

    override func setUp() {
        fakeNavigationController = FakeUINavigationController()
        sut = DefaultAlertPresenter()
    }

    func test_whenInfoAlertIsRequested_shouldPresentAppropriateAlertController() {
        // given:
        let fixtureTitle = "fixtureTitle"
        let fixtureMessage = "fixtureMessage"
        let fixtureButtonTitle = "fixtureButtonTitle"
        var didComplete: Bool?

        // when:
        sut.showInfoAlert(
            on: fakeNavigationController,
            title: fixtureTitle,
            message: fixtureMessage,
            buttonTitle: fixtureButtonTitle
        ) {
            didComplete = true
        }

        // then:
        XCTAssertEqual(fakeNavigationController.lastPresentedViewController, sut.alertController, "Should present alert controller")
        XCTAssertEqual(sut.alertController?.title, fixtureTitle, "Should assign appropriate title to alert controller")
        XCTAssertEqual(sut.alertController?.message, fixtureMessage, "Should assign appropriate message to alert controller")
        XCTAssertEqual(sut.alertController?.actions.first?.title, fixtureButtonTitle, "Should assign appropriate message to action button")
        XCTAssertEqual(sut.alertController?.preferredStyle, .alert, "Should assign appropriate style to alert controller")
        XCTAssertEqual(sut.alertController?.actions.count, 1, "Should add two actions")

        // when:
        sut.alertController?.tapButton(atIndex: 0)

        // then:
        XCTAssertEqual(didComplete, true, "Should execute completion block")

        // given:
        didComplete = nil

        // when:
        sut.showInfoAlert(on: fakeNavigationController, title: fixtureTitle, message: fixtureMessage) {
            didComplete = true
        }

        // then:
        XCTAssertEqual(fakeNavigationController.lastPresentedViewController, sut.alertController, "Should present alert controller")
        XCTAssertEqual(sut.alertController?.title, fixtureTitle, "Should assign appropriate title to alert controller")
        XCTAssertEqual(sut.alertController?.message, fixtureMessage, "Should assign appropriate message to alert controller")
        XCTAssertEqual(sut.alertController?.actions.first?.title, "OK", "Should assign default message to action button")
        XCTAssertEqual(sut.alertController?.preferredStyle, .alert, "Should assign appropriate style to alert controller")
        XCTAssertEqual(sut.alertController?.actions.count, 1, "Should add two actions")
    }

    func test_whenAcceptanceAlertIsRequested_shouldPresentAppropriateAlertController() {
        // given:
        let fixtureTitle = "fixtureTitle"
        let fixtureMessage = "fixtureMessage"
        let fixtureYesButtonTitle = "fixtureYesButtonTitle"
        let fixtureYesButtonStyle = UIAlertAction.Style.destructive
        let fixtureNoButtonTitle = "fixtureNoButtonTitle"
        let fixtureNoButtonStyle = UIAlertAction.Style.default
        var lastSelectedAction: AcceptanceAlertAction?

        // when:
        sut.showAcceptanceAlert(
            on: fakeNavigationController,
            title: fixtureTitle,
            message: fixtureMessage,
            yesActionTitle: fixtureYesButtonTitle,
            noActionTitle: fixtureNoButtonTitle,
            yesActionStyle: fixtureYesButtonStyle,
            noActionStyle: fixtureNoButtonStyle
        ) { action in
            lastSelectedAction = action
        }

        // then:
        XCTAssertEqual(fakeNavigationController.lastPresentedViewController, sut.alertController, "Should present alert controller")
        XCTAssertEqual(sut.alertController?.title, fixtureTitle, "Should assign appropriate title to alert controller")
        XCTAssertEqual(sut.alertController?.message, fixtureMessage, "Should assign appropriate message to alert controller")
        XCTAssertEqual(sut.alertController?.actions.first?.title, fixtureYesButtonTitle, "Should assign appropriate message to action button")
        XCTAssertEqual(sut.alertController?.actions.first?.style, fixtureYesButtonStyle, "Should assign appropriate styl to action button")
        XCTAssertEqual(sut.alertController?.actions.last?.title, fixtureNoButtonTitle, "Should assign appropriate message to action button")
        XCTAssertEqual(sut.alertController?.actions.last?.style, fixtureNoButtonStyle, "Should assign appropriate styl to action button")
        XCTAssertEqual(sut.alertController?.preferredStyle, .alert, "Should assign appropriate style to alert controller")
        XCTAssertEqual(sut.alertController?.actions.count, 2, "Should add two actions")

        // when:
        sut.alertController?.tapButton(atIndex: 0)

        // then:
        XCTAssertEqual(lastSelectedAction, .yes, "Should execute completion block with proper answer")

        // given:
        lastSelectedAction = nil

        // when:
        sut.showAcceptanceAlert(on: fakeNavigationController, title: fixtureTitle, message: fixtureMessage) { action in
            lastSelectedAction = action
        }

        // then:
        XCTAssertEqual(fakeNavigationController.lastPresentedViewController, sut.alertController, "Should present alert controller")
        XCTAssertEqual(sut.alertController?.title, fixtureTitle, "Should assign appropriate title to alert controller")
        XCTAssertEqual(sut.alertController?.message, fixtureMessage, "Should assign appropriate message to alert controller")
        XCTAssertEqual(sut.alertController?.actions.first?.title, "Yes", "Should assign appropriate message to action button")
        XCTAssertEqual(sut.alertController?.actions.first?.style, UIAlertAction.Style.default, "Should assign appropriate styl to action button")
        XCTAssertEqual(sut.alertController?.actions.last?.title, "No", "Should assign appropriate message to action button")
        XCTAssertEqual(sut.alertController?.actions.last?.style, UIAlertAction.Style.default, "Should assign appropriate styl to action button")
        XCTAssertEqual(sut.alertController?.preferredStyle, .alert, "Should assign appropriate style to alert controller")
        XCTAssertEqual(sut.alertController?.actions.count, 2, "Should add two actions")

        // when:
        sut.alertController?.tapButton(atIndex: 1)

        // then:
        XCTAssertEqual(lastSelectedAction, .no, "Should execute completion block with proper answer")
    }
}
