//
//  MainAppFlowCoordinator.swift
//  KISS Views
//

import SwiftUI
import UIKit

/// A flow coordinator handling main app routes.
final class MainAppFlowCoordinator: FlowCoordinator {

    /// - SeeAlso: FlowCoordinator.parent
    let parent: FlowCoordinator?

    /// - SeeAlso: FlowCoordinator.completionCallback
    var completionCallback: (() -> Void)?

    /// - SeeAlso: FlowCoordinator.adaptivePresentationDelegate
    var adaptivePresentationDelegate: UIAdaptivePresentationControllerDelegate?

    /// - SeeAlso: FlowCoordinator.child
    private(set) var child: FlowCoordinator? = nil

    /// - SeeAlso: FlowCoordinator.navigator
    private(set) var navigator: Navigator

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
        let initialRoute = MainAppRoute.assetsList
        let assetsList = makeViewComponents(forRoute: initialRoute, withData: nil)[0]
        assetsList.route = initialRoute
        navigator.pushViewController(assetsList.viewController, animated: animated)
    }

    /// - SeeAlso: FlowCoordinator.stop()
    func stop() {
        child?.stop()
        child = nil
        completionCallback?()
    }

    /// - SeeAlso: FlowCoordinator.show(route:withData:)
    func canShow(route: any Route) -> Bool {
        route as? MainAppRoute != nil
    }

    /// - SeeAlso: FlowCoordinator.navigateBack(animated:)
    func navigateBack(animated: Bool) {
        if let presentedViewController = navigator.presentedViewController {
            presentedViewController.dismiss(animated: animated)
        } else if navigator.viewControllers.count > 1 {
            _ = navigator.popViewController(animated: animated)
        }
    }

    /// - SeeAlso: FlowCoordinator.navigateBackToRoot(animated:)
    func navigateBackToRoot(animated: Bool) {
        _ = navigator.popToRootViewController(animated: animated)
    }

    /// - SeeAlso: FlowCoordinator.navigateBack(toRoute:animated:)
    func navigateBack(toRoute route: any Route, animated: Bool) {}

    /// - SeeAlso: FlowCoordinator.makeViewComponents(forRoute:withData:)
    func makeViewComponents(forRoute route: any Route, withData: AnyHashable?) -> [ViewComponent] {
        guard let route = route as? MainAppRoute else {
            fatalError("Route \(route) is not supported by MainAppFlowCoordinator")
        }

        switch route {
        case .assetsList:
            let assetListViewController = makeAssetListViewController()
            addNavigationBarButtons(uiViewController: assetListViewController)
            return [assetListViewController]

        case let .assetDetails(assetId):
            return [makeAssetDetailsViewController(assetId: assetId)]

        case let .editAsset(assetId):
            return [makeEditAssetViewController(assetId: assetId)]

        case let .restoreNavigation(assetId):
            return [
                makeAssetDetailsViewController(assetId: assetId),
                makeEditAssetViewController(assetId: assetId)
            ]

        default:
            fatalError("Route \(route) is not supported by MainAppFlowCoordinator")
        }
    }

    /// - SeeAlso: FlowCoordinator.makeFlowCoordinator(forRoute:navigator,withData:)
    func makeFlowCoordinator(forRoute route: any Route, navigator: Navigator, withData: AnyHashable?) -> FlowCoordinator {
        guard let route = route as? MainAppRoute else {
            fatalError("Route \(route) is not supported by MainAppFlowCoordinator")
        }

        switch route {

        // Discuss: These are showcase routes only ...
        // ... they're demonstrating that you can launch an instance of Main Flow coordinator from an existing one ...
        // ... a.k.a. "embedded" / "inception" flow.
        case .embeddedMainAppFlow, .popupMainAppFlow:
            let flowCoordinator = MainAppFlowCoordinator(
                navigator: navigator,
                dependencyProvider: dependencyProvider,
                parent: self
            )
            child = flowCoordinator
            return flowCoordinator

        default:
            fatalError("Route \(route) is not supported by MainAppFlowCoordinator")
        }
    }

    /// - SeeAlso: FlowCoordinator.handleChildCoordinatorFinished(executeBackNavigation:)
    ///
    /// - Parameter executeBackNavigation: a flag indicating whether to execute back navigation. On manual popup dismissal this should be set to `false`.
    func handleChildCoordinatorFinished(executeBackNavigation: Bool) {
        if executeBackNavigation {
            navigateBack()
        }
        child = nil
    }
}

private extension MainAppFlowCoordinator {

    @objc func embeddedNavigationButtonTapped() {
        show(route: MainAppRoute.embeddedMainAppFlow)
    }

    @objc func popupNavigationButtonTapped() {
        show(route: MainAppRoute.popupMainAppFlow)
    }

    @objc func restoreNavigationButtonTapped() {
        if let firstAsset = dependencyProvider.favouriteAssetsManager.retrieveFavouriteAssets().first {
            show(route: MainAppRoute.restoreNavigation(assetId: firstAsset.id))
        }
    }

    @objc func closeButtonTapped() {
        stop()
        if parent == nil, let rootView = navigator as? RootView {
            rootView.markForTakedown()
        }
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
        let closeButton = UIBarButtonItem(
            barButtonSystemItem: .close,
            target: self,
            action: #selector(closeButtonTapped)
        )
        uiViewController.navigationItem.rightBarButtonItems = [
            embeddedNavigationButton,
            popupNavigationButton,
            restoreNavigationButton,
            closeButton
        ]
    }
}
