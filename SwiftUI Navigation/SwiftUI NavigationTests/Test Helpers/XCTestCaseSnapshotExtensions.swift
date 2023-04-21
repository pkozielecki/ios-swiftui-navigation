//
//  XCTestCaseSnapshotExtensions.swift
//  KISS Views
//

import SnapshotTesting
import UIKit
import XCTest

extension XCTestCase {

    func executeSnapshotTests(
        forViewController viewController: UIViewController,
        named name: String,
        precision: Float = 0.995,
        file: StaticString = #file,
        functionName: String = #function,
        line: UInt = #line
    ) {
        assertSnapshot(
            matching: viewController,
            as: .image(on: .iPhone12, precision: precision, perceptualPrecision: precision),
            named: name,
            file: file,
            testName: "iPhone12",
            line: line
        )
    }
}
