//
//  NSString+.swift
//  Base
//
//  Created by pineone on 2021/09/02.
//

import Foundation

extension NSString {
    class func swizzleReplacingCharacters() {
        let originalMethod = class_getInstanceMethod(
        NSString.self, #selector(NSString.replacingCharacters(in:with:)))

        let swizzledMethod = class_getInstanceMethod(
        NSString.self, #selector(NSString.swizzledReplacingCharacters(in:with:)))

        guard let original = originalMethod, let swizzled = swizzledMethod else {
            return
        }

        method_exchangeImplementations(original, swizzled)
    }

    @objc func swizzledReplacingCharacters(in range: NSRange, with replacement: String) -> String {
        return self.swizzledReplacingCharacters(in: range, with: replacement)
    }
}
