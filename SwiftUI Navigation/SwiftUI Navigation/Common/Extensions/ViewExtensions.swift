//
//  ViewExtensions.swift
//  KISS Views
//

import SwiftUI
import UIKit

extension View {

    /// Wraps a SwiftUI View into a UIViewController.
    public var viewController: UIViewController {
        UIHostingController(rootView: self)
    }
}
