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
        let initialRoute = MainAppRoute.assetsList
        let assetsList = makeViewComponent(forRoute: initialRoute, withData: nil)
        assetsList.route = initialRoute
        navigator.setViewControllers([assetsList.viewController], animated: animated)
    }

    /// - SeeAlso: FlowCoordinator.stop()
    func stop() {}

    /// - SeeAlso: FlowCoordinator.show(route:withData:)
    func canShow(route: any Route) -> Bool {
        route as? MainAppRoute != nil
    }

    /// - SeeAlso: FlowCoordinator.navigateBack(animated:)
    func navigateBack(animated: Bool) {
        guard navigator.viewControllers.count > 1 else {
            return
        }

        _ = navigator.popViewController(animated: animated)
    }

    /// - SeeAlso: FlowCoordinator.navigateBackToRoot(animated:)
    func navigateBackToRoot(animated: Bool) {
        _ = navigator.popToRootViewController(animated: animated)
    }

    /// - SeeAlso: FlowCoordinator.navigateBack(toRoute:animated:)
    func navigateBack(toRoute route: any Route, animated: Bool) {}

    /// - SeeAlso: FlowCoordinator.makeViewComponent(forRoute:withData:)
    func makeViewComponent(forRoute route: any Route, withData: AnyHashable?) -> ViewComponent {
        guard let route = route as? MainAppRoute else {
            fatalError("Route \(route) is not supported by MainAppFlowCoordinator")
        }

        switch route {
        case .assetsList:
            let assetListViewController = makeAssetListViewController()
            addNavigationBarButtons(uiViewController: assetListViewController)
            return assetListViewController

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

    @objc func embeddedNavigationButtonTapped() {
        print("embeddedNavigationButtonTapped")
    }

    @objc func popupNavigationButtonTapped() {
        print("popupNavigationButtonTapped")
    }

    @objc func restoreNavigationButtonTapped() {
        print("restoreNavigationButtonTapped")
    }

    //  Discussion: This can be moved to a dedicated factory / view builder in the future.
    //  This way we can reuse the code to make these views in other places.

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

    func addNavigationBarButtons(uiViewController: UIViewController) {
        let embeddedNavigationButton = UIBarButtonItem(
            image: UIImage(systemName: "character.duployan"),
            style: .plain,
            target: self,
            action: #selector(embeddedNavigationButtonTapped)
        )
        let popupNavigationButton = UIBarButtonItem(
            image: UIImage(systemName: "note"),
            style: .plain,
            target: self,
            action: #selector(popupNavigationButtonTapped)
        )
        let restoreNavigationButton = UIBarButtonItem(
            image: UIImage(systemName: "icloud.and.arrow.down.fill"),
            style: .plain,
            target: self,
            action: #selector(restoreNavigationButtonTapped)
        )
        uiViewController.navigationItem.leftBarButtonItems = [embeddedNavigationButton, popupNavigationButton, restoreNavigationButton]
    }
}
