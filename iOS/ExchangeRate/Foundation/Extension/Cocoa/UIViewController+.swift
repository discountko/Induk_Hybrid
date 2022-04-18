//
//  UIViewController+.swift
//  Base
//
//  Created by pineone on 2021/09/02.
//
import UIKit

extension UIViewController {
    private struct RuntimeKey {
        static let indexKey = UnsafeRawPointer(bitPattern: "indexKey".hashValue)
    }

    public var index: Int {
        set {
            objc_setAssociatedObject(self, RuntimeKey.indexKey!, NSNumber(value: newValue), .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }

        get {
            return  (objc_getAssociatedObject(self, RuntimeKey.indexKey!) as! NSNumber).intValue
        }
    }
}
