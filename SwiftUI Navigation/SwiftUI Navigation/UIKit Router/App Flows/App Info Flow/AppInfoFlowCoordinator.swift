//
//  AppInfoFlowCoordinator.swift
//  KISS Views
//

import SwiftUI
import UIKit

/// A coordinator handling add asset flow.
final class AppInfoFlowCoordinator: FlowCoordinator {

    /// - SeeAlso: FlowCoordinator.parent
    let parent: FlowCoordinator?

    /// - SeeAlso: FlowCoordinator.completionCallback
    var completionCallback: (() -> Void)?

    /// - SeeAlso: FlowCoordinator.adaptivePresentationDelegate
    let adaptivePresentationDelegate: UIAdaptivePresentationControllerDelegate? = nil

    /// - SeeAlso: FlowCoordinator.child
    var child: FlowCoordinator? = nil

    /// - SeeAlso: FlowCoordinator.navigator
    let navigator: Navigator

    private let dependencyProvider: DependencyProvider

    /// A default initializer for MainAppFlowCoordinator.
    ///
    /// - Parameters:
    ///   - navigator: a navigator.
    ///   - dependencyProvider: a dependency provider.
    ///   - parent: a flow coordinator parent.
    init(
        navigator: Navigator,
        dependencyProvider: DependencyProvider,
        parent: FlowCoordinator? = nil
    ) {
        self.navigator = navigator
        self.dependencyProvider = dependencyProvider
        self.parent = parent
    }

    /// - SeeAlso: FlowCoordinator.start(animated:)
    func start(animated: Bool) {
        let initialRoute = AppInfoRoute.appInfo
        let appInfo = makeViewComponents(forRoute: initialRoute, withData: nil)[0]
        appInfo.route = initialRoute
        navigator.pushViewController(appInfo.viewController, animated: animated)
        initialInternalRoute = initialRoute
    }

    /// - SeeAlso: FlowCoordinator.stop()
    func stop() {
        cleanUpNavigationStack()
        completionCallback?()
    }

    /// - SeeAlso: FlowCoordinator.show(route:withData:)
    func canShow(route: any Route) -> Bool {
        route as? AppInfoRoute != nil
    }

    /// - SeeAlso: FlowCoordinator.makeViewComponents(forRoute:withData:)
    func makeViewComponents(forRoute route: any Route, withData: AnyHashable?) -> [ViewComponent] {
        guard let route = route as? AppInfoRoute else {
            fatalError("Route \(route) is not supported by AppInfoFlowCoordinator")
        }

        switch route {
        case .appInfo:
            return [makeAppInfoViewController()]
        }
    }

    /// - SeeAlso: FlowCoordinator.makeFlowCoordinator(forRoute:navigator:withData:)
    func makeFlowCoordinator(forRoute route: any Route, navigator: Navigator, withData: AnyHashable?) -> FlowCoordinator {
        fatalError("makeFlowCoordinator(forRoute:navigator:withData:) has not been implemented")
    }
}

private extension AppInfoFlowCoordinator {

    func makeAppInfoViewController() -> ViewComponent {
        let viewModel = UIKitRouterAppInfoViewModel(
            router: dependencyProvider.router
        )
        return AppInfoView(viewModel: viewModel).viewController
    }
}
