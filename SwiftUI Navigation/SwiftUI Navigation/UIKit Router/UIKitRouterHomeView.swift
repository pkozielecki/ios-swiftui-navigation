//
//  UIKitRouterHomeView.swift
//  KISS Views
//

import SwiftUI
import UIKit

/// A SwiftUI wrapper for UIKit Router navigation.
struct UIKitRouterHomeView: UIViewControllerRepresentable {
    typealias UIViewControllerType = RootViewController

    private let completion: (() -> Void)?

    /// A default initializer for UIKitRouterHomeView.
    /// 
    /// - Parameter completion: a completion callback.
    init(completion: (() -> Void)?) {
        self.completion = completion
    }

    func makeUIViewController(context: Context) -> UIViewControllerType {
        RootViewController(completion: completion)
    }

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}

    func dismantleUIViewController(_ uiViewController: UIViewControllerType, coordinator: Void) {}

    func makeCoordinator() {}

    func sizeThatFits(_ proposal: ProposedViewSize, uiViewController: UIViewControllerType, context: Context) -> CGSize? {
        guard let width = proposal.width, let height = proposal.height else {
            return nil
        }
        return uiViewController.view.sizeThatFits(CGSize(width: width, height: height))
    }
}
