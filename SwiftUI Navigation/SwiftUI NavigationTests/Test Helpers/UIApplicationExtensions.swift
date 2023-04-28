//
//  UIApplicationExtensions.swift
//  KISS Views
//

import UIKit

extension UIApplication {

    var keySceneWindow: UIWindow? {
        let connectedScenes = UIApplication.shared.connectedScenes
        for scene in connectedScenes {
            if let windowScene = scene as? UIWindowScene {
                for window in windowScene.windows {
                    if window.isKeyWindow {
                        return window
                    }
                }
            }
        }
        return nil
    }
}
