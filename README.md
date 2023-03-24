# SwiftUI Navigation Showcase

Welcome to the demonstration of **different ways** to implement **scalable navigation** in **SwiftUI** projects.

## Main Features
Showcase of 3 most reliable, currently available ways to implement SwiftUI navigation to be:
* precise - we can define precisely which view (and how) will be shown 
* scalable - as the application grows, the navigation component allows adding new views and app flows 
* stateful - it is possible to set up or restore the entire navigation stack (e.g. when activating a deep link)
* self-dismissible - a popup or a view can be dismissed / popped programmatically 
* testable

## Integration

### Requirements
* iOS 16.0

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

### Navigation modelled as a part of View state

Originally introduced by Brandon and Stephen from PointFree in their [episodes](https://www.pointfree.co/blog/posts/66-open-sourcing-swiftui-navigation) about SwiftUI Navigation.
* A drill-down type of navigation
* Uses `destination` field in the view state to define which view or popup to display

### UIKit-based navigation

* Implements the navigation classical way - using `UINavigationController`
* SwiftUI Views are embedded into `HostingViewControllers`

## Project maintainer

- [Pawel Kozielecki](https://github.com/pkozielecki)

See also the list of [contributors](https://github.com/netguru/ng-ios-network-module/contributors) who participated in this project.

## License

This project is licensed under the MIT License.
[More info](LICENSE.md)
