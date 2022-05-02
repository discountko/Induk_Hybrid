//
//  Toast.swift
//  ExchangeRate
//
//  Created by pineone on 2022/05/02.
//

import UIKit

struct Toast {
    
    static func show(_ text: String) {
        if AppDelegate.shared.isShowingKeyboard {
            showOnKeyboard(text)
        } else {
            showOnNoKeyboard(text)
        }
    }
    
    static func showOnNoKeyboard(_ text: String) {
        if let currentToast = ToastCenter.default.currentToast {
            currentToast.cancel()
        }
        DispatchQueue.main.async {
            if UIApplication.shared.topViewController?.tabBarController?.tabBar.isHidden ?? false {
                ToastView.appearance().bottomOffsetPortrait = 64
            } else {
                ToastView.appearance().bottomOffsetPortrait = BaseTabBarController.shared.tabBarHeight + 12
            }
        }
        Toaster(text: text).show()
    }

    static func showOnKeyboard(_ text: String) {
        if let currentToast = ToastCenter.default.currentToast {
            currentToast.cancel()
        }

        DispatchQueue.main.async {
            if UIApplication.shared.topViewController?.tabBarController?.tabBar.isHidden ?? false {
                ToastView.appearance().bottomOffsetPortrait = 64
            } else {
                ToastView.appearance().bottomOffsetPortrait = BaseTabBarController.shared.tabBarHeight + 12
            }
        }
        Toaster(text: text, type: .onKeyboard).show()
    }

}

