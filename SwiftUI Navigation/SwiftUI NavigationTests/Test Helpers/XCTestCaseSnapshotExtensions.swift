//
//  XCTestCaseSnapshotExtensions.swift
//  KISS Views
//

import SnapshotTesting
import SwiftUI
import UIKit
import XCTest

extension XCTestCase {

    //  Executes a snapshot tests for a provided SwiftUI view:
    func executeSnapshotTests(
        forView view: any View,
        named name: String,
        precision: Float = 0.995,
        isRecording: Bool = false,
        file: StaticString = #file,
        functionName: String = #function,
        line: UInt = #line
    ) {
        executeSnapshotTests(
            forViewController: view.viewController,
            named: name,
            precision: precision,
            isRecording: isRecording,
            file: file,
            functionName: functionName,
            line: line
        )
    }

    //  Executes a snapshot tests for a provided UIViewController:
    func executeSnapshotTests(
        forViewController viewController: UIViewController,
        named name: String,
        precision: Float = 0.995,
        isRecording: Bool = false,
        file: StaticString = #file,
        functionName: String = #function,
        line: UInt = #line
    ) {
        viewController.loadViewIfNeeded()
        viewController.forceLightMode()
        assertSnapshot(
            matching: viewController,
            as: .image(on: .iPhone12, precision: precision, perceptualPrecision: 0.95),
            named: name,
            record: isRecording,
            file: file,
            testName: "iPhone12",
            line: line
        )
    }

    //  Executes a snapshot tests for a provided app window (entire screen):
    func executeSnapshotTests(
        appWindow window: UIWindow,
        named name: String,
        isRecording: Bool = false,
        file: StaticString = #file,
        functionName: String = #function,
        line: UInt = #line
    ) {
        assertSnapshot(
            matching: window,
            as: .appWindow,
            named: name,
            record: isRecording,
            file: file,
            testName: "iPhone12",
            line: line
        )
    }

    // Discussion: Introducing slight delay to allow display list to redraw before making a snapshot"
    func waitForDisplayListRedraw(delay: Double = 1) {
        let expectation = expectation(description: "waitForDisplayListRedraw")

        //  when:
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            expectation.fulfill()
        }

        //  then:
        wait(for: [expectation])
    }

    // Discussion: Introducing longer delay to allow view hierarchy on the main app window to redraw:
    func waitForViewHierarchyRedraw(window: UIWindow, delay: Double = 3) {
        let expectation = expectation(description: "waitForViewHierarchyRedraw")
        UIView.setAnimationsEnabled(false)

        DispatchQueue.main.async {
            window.drawHierarchy(in: window.bounds, afterScreenUpdates: true)

            //  Discussion: Although `UIView.setAnimationsEnabled(false)` works for most UIKit animations,
            //  it does not work for all of them, including presenting an alert and a popup,
            //  so, we need to wait for the animation to play out...
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                expectation.fulfill()
            }

            UIView.setAnimationsEnabled(true)
        }

        wait(for: [expectation])
    }

    // Discussion: Retrieves app key window (if exists) and attaches provided view as its root:
    func getAppKeyWindow(withRootViewController viewController: UIViewController) -> UIWindow? {
        guard let window = UIApplication.shared.keySceneWindow else {
            return nil
        }

        window.overrideUserInterfaceStyle = .light
        window.rootViewController = viewController
        viewController.loadViewIfNeeded()
        return window
    }
}
