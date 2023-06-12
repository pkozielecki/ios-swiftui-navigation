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
* Run `SwiftUI Navigation` scheme.

## Showcased navigation types

### SwiftUI Router

Utilises iOS 16 `Navigation Stack` and `navigationDestination` API to handle navigation
* Uses `Router` component to execute navigation commands (e.g. push, pop, present, etc.)
* The `Router` is bound strictly with the View implementing `Navigation Stack`
* API very similar to `UINavigationController`

| ![](External%20Resources/push_pop.gif) | ![](External%20Resources/present_dismiss.gif) | ![](External%20Resources/alert.gif) | ![](External%20Resources/drill_down.gif) | ![](External%20Resources/inline_inception.gif) | ![](External%20Resources/popup_inception.gif) |
|----------------------------------------|-----------------------------------------------|-------------------------------------|------------------------------------------|------------------------------------------------|-----------------------------------------------|


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
