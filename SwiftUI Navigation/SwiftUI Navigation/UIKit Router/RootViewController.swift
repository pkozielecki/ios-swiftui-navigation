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
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// - SeeAlso: UIViewController.viewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBarHidden(true, animated: false)
        createComebackButton()
    }
}

// MARK: - Private

private extension RootViewController {
    
    @objc func buttonTapped() {
        completion?()
    }

    func createComebackButton() {
        // Temporary button to go back to SwiftUI.
        let button = UIButton(type: .system)
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        button.setTitle("Go back", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)
        button.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        button.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
}
