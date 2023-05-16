//
//  UIKitRouterHomeView.swift
//  KISS Views
//

import SwiftUI
import UIKit

/// A SwiftUI wrapper for UIKit Router navigation.
struct UIKitRouterHomeView: UIViewControllerRepresentable {
    typealias UIViewControllerType = RootViewController

    private var rootViewController: RootViewController
    private var dependencyProvider: DependencyProvider

    /// A default initializer for UIKitRouterHomeView.
    ///
    /// - Parameter completion: a completion callback.
    init(completion: (() -> Void)?) {
        // TODO: Stop current flow coordinator.
        rootViewController = RootViewController(completion: completion)
        dependencyProvider = DefaultDependencyProvider(rootViewController: rootViewController)
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
