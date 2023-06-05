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

        case .appInfoStandalone:
            return [makeAppInfoViewController()]

        case let .restoreNavigation(assetId):
            // Discussion: You need to manually assign the route to the view controller if restoring a navi stack.
            let detailsViewController = makeAssetDetailsViewController(assetId: assetId)
            detailsViewController.route = MainAppRoute.assetDetails(assetId: assetId)
            let editAssetViewController = makeEditAssetViewController(assetId: assetId)
            editAssetViewController.route = MainAppRoute.editAsset(assetId: assetId)
            return [
                detailsViewController,
                editAssetViewController
            ]

        case .restorePopupNavigation:
            // Discussion: You need to manually assign the route to the view controller if restoring a navi stack.
            let appInfoViewController = makeAppInfoViewController()
            appInfoViewController.route = MainAppRoute.addAsset // Done on purpose - to distinguish the two instances.
            let appInfoViewController2 = makeAppInfoViewController()
            appInfoViewController2.route = MainAppRoute.appInfoStandalone
            return [
                appInfoViewController,
                appInfoViewController2
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

        case .addAsset:
            let flowCoordinator = AddAssetFlowCoordinator(
                navigator: navigator,
                dependencyProvider: dependencyProvider,
                parent: self
            )
            child = flowCoordinator
            return flowCoordinator

        case .appInfo:
            let flowCoordinator = AppInfoFlowCoordinator(
                navigator: navigator,
                dependencyProvider: dependencyProvider,
                parent: self
            )
            child = flowCoordinator
            return flowCoordinator

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

    func makeAppInfoViewController() -> ViewComponent {
        let viewModel = UIKitRouterAppInfoViewModel(
            router: dependencyProvider.router
        )
        return AppInfoView(viewModel: viewModel).viewController
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
