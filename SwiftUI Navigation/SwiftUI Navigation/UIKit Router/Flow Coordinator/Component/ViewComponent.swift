//
//  ViewComponent.swift
//  KISS Views
//

import ObjectiveC
import UIKit

/// An associated object key for a View Component route.
private var ViewComponentRouteKey: UInt8 = 123

/// An abstraction describing an UIKit visual component (a view that takes up entire screen).
protocol ViewComponent: AnyObject {

    /// A reference to a view controller.
    var viewController: UIViewController { get }

    /// A route associated with the component.
    var route: any Route { get set }
}

extension UIViewController: ViewComponent {

    /// - SeeAlso: ViewComponent.viewController
    var viewController: UIViewController {
        self
    }

    /// - SeeAlso: ViewComponent.route
    var route: any Route {
        get {
            objc_getAssociatedObject(self, &ViewComponentRouteKey) as? any Route ?? EmptyRoute()
        }
        set {
            objc_setAssociatedObject(self, &ViewComponentRouteKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}
