//
//  UIKitRouterHomeView.swift
//  KISS Views
//

import SwiftUI
import UIKit

/// A SwiftUI wrapper for UIKit Router navigation.
struct UIKitRouterHomeView: UIViewControllerRepresentable {
    typealias UIViewControllerType = RootViewController

    private let dependencyProvider: DependencyProvider
    private let rootViewController: RootViewController

    /// A default initializer for UIKitRouterHomeView.
    ///
    /// - Parameters:
    ///   - dependencyProvider: a dependency provider.
    ///   - rootViewController: a root view controller.
    init(
        dependencyProvider: DependencyProvider,
        rootViewController: RootViewController
    ) {
        self.dependencyProvider = dependencyProvider
        self.rootViewController = rootViewController
        // TODO: Stop current flow coordinator when the completion is called.
    }

    func makeUIViewController(context: Context) -> UIViewControllerType {
        router.startInitialFlow(dependencyProvider: dependencyProvider, animated: false)
        return rootViewController
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

private extension UIKitRouterHomeView {

    var router: UIKitNavigationRouter {
        dependencyProvider.router
    }
}
