//
//  SnapshottingExtensions.swift
//  KISS Views
//

import SnapshotTesting
import SwiftUI
import UIKit
import XCTest

// Discussion: An extension to SnapshotTesting library allowing to make a snapshot of an entire key app Window.
extension Snapshotting where Value: UIWindow, Format == UIImage {
    static var appWindow: Snapshotting {
        Snapshotting<UIImage, UIImage>.image.asyncPullback { window in
            Async<UIImage> { callback in
                UIView.setAnimationsEnabled(false)
                DispatchQueue.main.async {
                    let image = UIGraphicsImageRenderer(bounds: window.bounds).image { _ in
                        window.drawHierarchy(in: window.bounds, afterScreenUpdates: true)
                    }
                    callback(image)
                    UIView.setAnimationsEnabled(true)
                }
            }
        }
    }
}
