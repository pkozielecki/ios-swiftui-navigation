//
//  ViewExtension.swift
//  KISS Views
//

import SwiftUI
import UIKit

extension View {

    func wrappedInHostingViewController() -> UIViewController {
        UIHostingController(rootView: self)
    }
}
