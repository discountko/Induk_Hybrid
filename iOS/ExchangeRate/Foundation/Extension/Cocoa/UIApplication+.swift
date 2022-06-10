//
//  UIApplication+.swift
//  Base
//
//  Created by pineone on 2021/09/02.
//

import UIKit

extension UIApplication {
    public var topViewController: UIViewController? {
        return UIApplication.getTopViewController()
    }

    class func getTopViewController(base: UIViewController? = UIApplication.shared.keyWindowInConnectedScenes?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return getTopViewController(base: nav.visibleViewController)
        } else if let tab = base as? UITabBarController, let selected = tab.selectedViewController {
            return getTopViewController(base: selected)
        } else if let presented = base?.presentedViewController {
            return getTopViewController(base: presented)
        }
        return base
    }

    @available(iOS 13.0, *)
     var windowScene: UIWindowScene? {
         return connectedScenes
             .first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene
     }

     var keyWindowInConnectedScenes: UIWindow? {
         if #available(iOS 13.0, *) {
            return UIApplication.shared.windows.filter { $0.isKeyWindow }.first
         } else {
            return UIApplication.shared.keyWindow
         }
     }
}
