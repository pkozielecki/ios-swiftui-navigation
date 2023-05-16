//
//  MainAppFlowCoordinator.swift
//  KISS Views
//

import SwiftUI
import UIKit

/// A flow coordinator handling main app routes.
final class MainAppFlowCoordinator: FlowCoordinator {

    /// - SeeAlso: FlowCoordinator.parent
    let parent: FlowCoordinator? = nil

    /// - SeeAlso: FlowCoordinator.navigator
    private(set) var navigator: Navigator

    private let dependencyProvider: DependencyProvider

    /// A default initializer for MainAppFlowCoordinator.
    ///
    /// - Parameters:
    ///   - navigator: a navigator.
    ///   - dependencyProvider: a dependency provider.
    init(
        navigator: Navigator,
        dependencyProvider: DependencyProvider
    ) {
        self.navigator = navigator
        self.dependencyProvider = dependencyProvider
    }

    /// - SeeAlso: FlowCoordinator.start(animated:)
    func start(animated: Bool) {
        let assetsList = makeViewComponent(forRoute: MainAppRoute.assetsList, withData: nil)
        navigator.setViewControllers([assetsList.viewController], animated: animated)
    }

    /// - SeeAlso: FlowCoordinator.stop()
    func stop() {}

    /// - SeeAlso: FlowCoordinator.show(route:withData:)
    func canShow(route: any Route) -> Bool {
        //  TODO: Implement
        true
    }

    /// - SeeAlso: FlowCoordinator.navigateBack(animated:)
    func navigateBack(animated: Bool) {}

    /// - SeeAlso: FlowCoordinator.navigateBackToRoot(animated:)
    func navigateBackToRoot(animated: Bool) {}

    /// - SeeAlso: FlowCoordinator.navigateBack(toRoute:animated:)
    func navigateBack(toRoute route: any Route, animated: Bool) {}

    /// - SeeAlso: FlowCoordinator.makeViewComponent(forRoute:withData:)
    func makeViewComponent(forRoute route: any Route, withData: AnyHashable?) -> ViewComponent {
        guard let route = route as? MainAppRoute else {
            fatalError("Route \(route) is not supported by MainAppFlowCoordinator")
        }

        switch route {
        case .assetsList:
            return makeAssetListViewController()

        case let .assetDetails(assetId):
            return makeAssetDetailsViewController(assetId: assetId)

        case let .editAsset(assetId):
            return makeEditAssetViewController(assetId: assetId)
        }
    }

    /// - SeeAlso: FlowCoordinator.makeFlowCoordinator(forRoute:withData:)
    func makeFlowCoordinator(forRoute route: any Route, withData: AnyHashable?) -> FlowCoordinator {
        fatalError("makeFlowCoordinator(forRoute:withData:) has not been implemented")
    }
}

private extension MainAppFlowCoordinator {

    func makeAssetListViewController() -> UIViewController {
        let viewModel = UIKitRouterAssetsListViewModel(
            favouriteAssetsManager: dependencyProvider.favouriteAssetsManager,
            assetsRatesProvider: dependencyProvider.assetsRatesProvider,
            router: dependencyProvider.router
        )
        return AssetsListView(viewModel: viewModel).viewController
    }

    func makeAssetDetailsViewController(assetId: String) -> UIViewController {
        let viewModel = UIKitRouterAssetDetailsViewModel(
            assetId: assetId,
            favouriteAssetsManager: dependencyProvider.favouriteAssetsManager,
            historicalAssetRatesProvider: dependencyProvider.historicalAssetRatesProvider,
            router: dependencyProvider.router
        )
        return AssetDetailsView(viewModel: viewModel).viewController
    }

    func makeEditAssetViewController(assetId: String) -> UIViewController {
        let viewModel = UIKitRouterEditAssetViewModel(
            assetId: assetId,
            favouriteAssetsManager: dependencyProvider.favouriteAssetsManager,
            router: dependencyProvider.router
        )
        return EditAssetView(viewModel: viewModel).viewController
    }
}

extension View {

    var viewController: UIViewController {
        UIHostingController(rootView: self)
    }
}
