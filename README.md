# SwiftUI Navigation Showcase

Welcome to the demonstration of **different ways** to implement **scalable navigation** in **SwiftUI** projects.

## Main Features
Showcase of 2 most reliable, currently available ways to implement SwiftUI navigation:
* using **SwiftUIRouter** component
* using **UIKit-based navigation**

The grounds on which to assess the navigation solutions are:
* **precision** - we can define precisely which view (and how) will be shown 
* **scalability** - as the application grows, the navigation component allows adding new views and app flows 
* **being stateful** - it is possible to set up or restore the entire navigation stack (e.g. when activating a deep link)
* an ability to **self-dismiss** - a popup or a view can be dismissed / popped programmatically 
* **testability** - it is possible to test the navigation component in isolation

## Integration

### Requirements
* iOS 16.0 (SwiftUI-based navi)
* iOS 13.0 (UIKit-based navi)

### Running the app

* Clone the repo.
* Open `SwiftUI Navigation.xcodeproj` file.
* Edit `AppConfiguration.swift` file and enter valid https://metalpriceapi.com/ API key.
* Use `SwiftUI Navigation` scheme to run the application.
* Use `Tests` scheme to run unit tests.

## Showcased navigation types
* SwiftUI Router [see below](#swiftui-router)
* UIKit-based navigation [see below](#uikit-based-navigation)

### SwiftUI Router

Utilises iOS 16 `Navigation Stack` and `navigationDestination` API to handle navigation
* Uses `Router` component to execute navigation commands (e.g. push, pop, present, etc.)
* The `Router` is bound strictly with the View implementing `Navigation Stack`
* API very similar to `UINavigationController`

| ![](External%20Resources/push_pop.gif) | ![](External%20Resources/present_dismiss.gif) | ![](External%20Resources/alert.gif) | ![](External%20Resources/drill_down.gif) | ![](External%20Resources/inline_inception.gif) | ![](External%20Resources/popup_inception.gif) |
|----------------------------------------|-----------------------------------------------|-------------------------------------|------------------------------------------|------------------------------------------------|-----------------------------------------------|

#### Using SwiftUI Router

This type of navigation relies on 2 components bound together:
* A SwiftUI View:
  * Embeds `NavigationStack` component.
  * Implements `@ViewBuilder` functions that creates subviews to show in the NavStack.
  * Implements **view modifiers** telling the compiler how to present a particular view (e.g. as sheet or an alert)
  * Sample implementation [see below](#view-example), [go to code](https://github.com/pkozielecki/ios-swiftui-navigation/blob/main/SwiftUI%20Navigation/SwiftUI%20Navigation/SwiftUI%20Router/Router/SwiftUIRouterHomeView.swift)

* A Router:
  * A single source of truth about what view is shown at a given moment.
  * Provides reference to the navigation stack.
  * Implements methods to operate on the navigation stack (e.g. push, pop, return to root, etc.)
  * Protocol definition [see below](#router-protocol-definition)
  * Sample implementation [go to code](https://github.com/pkozielecki/ios-swiftui-navigation/blob/main/SwiftUI%20Navigation/SwiftUI%20Navigation/SwiftUI%20Router/Router/SwiftUINavigationRouter.swift)

##### View Example
```
struct SwiftUIRouterHomeView<Router: NavigationRouter>: View {
    @ObservedObject var router: Router

    var body: some View {
        NavigationStack(
            path: .init(
                get: {
                    router.navigationStack
                },
                set: { stack in
                    router.set(navigationStack: stack)
                })
        ) {
            MyInitialView()
                .navigationDestination(for: NavigationRoute.self) { route in
                    //  Handling app screens, pushed to the navigation stack
                }
                .sheet(item: $router.presentedPopup) { _ in
                    if let $popup = Binding($router.presentedPopup) {
                        //  Handling app popups, presented as sheets:
                    }
                }
                .alert(
                    presenting: $router.presentedAlert,
                    confirmationActionTitle: router.presentedAlert?.title.orEmpty,
                    confirmationActionCallback: { alertRoute in
                        //  Handling app alert confirmation action:
                    }
                )
        }
    }
}
```

##### Router protocol definition
```
protocol NavigationRouter: AnyObject, ObservableObject {

    /// A currently presented popup.
    var presentedPopup: PopupRoute? { get set }
    var presentedPopupPublished: Published<PopupRoute?> { get }
    var presentedPopupPublisher: Published<PopupRoute?>.Publisher { get }

    /// A currently presented alert.
    var presentedAlert: AlertRoute? { get set }
    var presentedAlertPublished: Published<AlertRoute?> { get }
    var presentedAlertPublisher: Published<AlertRoute?>.Publisher { get }

    /// A currently presented navigation route.
    var navigationRoute: NavigationRoute? { get }

    /// A complete navigation stack.
    /// Contains all navigation routes pushed to navigation stack.
    var navigationStack: [NavigationRoute] { get }

    /// Pushes screen to navigation stack.
    ///
    /// - Parameter screen: a screen to be pushed.
    func push(screen: NavigationRoute.Screen)

    /// Removes last view from the navigation stack.
    func pop()

    /// Pops navigation stack to root.
    func popAll()

    /// Replaces navigation stack.
    ///
    /// - Parameter navigationStack: a collection of routes to replace the stack with.
    func set(navigationStack: [NavigationRoute])

    /// Presents provided popup as sheet.
    ///
    /// - Parameter popup: a popup to present.
    func present(popup: PopupRoute.Popup)

    /// Dismisses current popup.
    func dismiss()

    /// Shows an alert.
    ///
    /// - Parameter alert: an alert to show.
    func show(alert: AlertRoute.Alert)

    /// Removes currently displayed alert from the navigation stack.
    func hideCurrentAlert()
}
```

#### Pros:
* **Precise**<br/>You can explicitly set which View is shown (and how) - though it’s not as clear as in UIKit (e.g. separate bindings exposed for controlling an alert, popup and navigation stack).
* **Scalable** to a degree<br/>You can display independent app flow on a popup, that opens another popup showing yet another flow, etc.
* **Stateful**<br/>You can save navigation path and then restore it on the Router to trigger Root View / Navigation Stack rebuilding the Views (a.k.a. drill-down navigation).
* **Testable**<br/>Router is fully testable. Router + Root View binding can be tested using integration tests like Snapshots.

#### Cons:
* iOS 16+ only<br/>requires `Navigation Stack`.
* Tight coupling between the `Root View` (the one with embedded NavigationStack) and the `Router`.
* Messy View factories in the Root View (thanks to `@ViewBuilder`). 
* Only a single alert or popup can be shown at a given moment.

#### Where to use:
* **Simple project, POC, etc.**<br/>Rule of the thumb: if we can manage with just one NavigationStack in the app, you'll be ok.
* **SwiftUI-only modules**<br/>Such modules have limited amount of screens to show and distinct point of entry where the these screens

---
    
### UIKit-based navigation

* Implements the navigation classical way - using `UINavigationController`
* SwiftUI Views are embedded into `HostingViewControllers`
* Uses a single point of entry to execute navigation commands - `UIKitNavigationRouter`
* Leverages `FlowCoordinator` to handle navigation flow for a given feature (e.g. registration, authentication, etc.)
* Every view shown is represented by a distinct `Route` object

| ![](External%20Resources/uikit_push.gif) | ![](External%20Resources/uikit_popup.gif) | ![](External%20Resources/uikit_alert.gif) | ![](External%20Resources/uikit_drilldown.gif) | ![](External%20Resources/uikit_inline_flow.gif) | ![](External%20Resources/uikit_flow_popup.gif) |
|------------------------------------------|-------------------------------------------|-------------------------------------------|-----------------------------------------------|-------------------------------------------------|------------------------------------------------|


## Project maintainer

- [Pawel Kozielecki](https://github.com/pkozielecki)

See also the list of [contributors](https://github.com/netguru/ng-ios-network-module/contributors) who participated in this project.

## License

This project is licensed under the MIT License.
[More info](LICENSE.md)
