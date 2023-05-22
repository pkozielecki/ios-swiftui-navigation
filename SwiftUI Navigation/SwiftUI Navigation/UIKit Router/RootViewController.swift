//
//  RootViewController.swift
//  KISS Views
//

import UIKit

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
        arrangeNavigationBar()
    }
}

// MARK: - Private

private extension RootViewController {

    @objc func closeButtonTapped() {
        completion?()
    }

    func arrangeNavigationBar() {
        let closeButton = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(closeButtonTapped))
        topViewController?.navigationItem.rightBarButtonItems = [closeButton]
        navigationBar.prefersLargeTitles = true
    }
}
