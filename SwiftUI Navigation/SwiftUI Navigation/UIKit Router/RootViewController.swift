//
//  RootViewController.swift
//  KISS Views
//

import UIKit

/// An abstraction describing a root view controller.
protocol RootView {

    /// Marks the root view for takedown.
    /// Call when you want want to remove or replace the root view controller for the app.
    func markForTakedown()
}

/// A UIKit navigation root view controller.
final class RootViewController: UINavigationController {
    private let completion: (() -> Void)?

    /// A default initializer for RootViewController.
    ///
    /// - Parameter completion: a completion block.
    init(completion: (() -> Void)?) {
        self.completion = completion
        super.init(nibName: nil, bundle: nil)
    }

    /// - SeeAlso: UIViewController.init(coder:)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// - SeeAlso: UIViewController.viewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBarHidden(false, animated: false)
    }
}

extension RootViewController: RootView {

    func markForTakedown() {
        completion?()
    }
}
