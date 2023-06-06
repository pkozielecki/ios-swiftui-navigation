//
//  UIAlertControllerExtensions.swift
//  KISS Views
//

import UIKit

extension UIAlertController {

    typealias AlertHandler = @convention(block) (UIAlertAction) -> Void

    func tapButton(atIndex index: Int) {
        if let block = actions[index].value(forKey: "handler") {
            let blockPtr = UnsafeRawPointer(Unmanaged<AnyObject>.passUnretained(block as AnyObject).toOpaque())
            let handler = unsafeBitCast(blockPtr, to: AlertHandler.self)
            handler(actions[index])
        }
    }
}
