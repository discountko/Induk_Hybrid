//
//  Color+.swift
//  Base
//
//  Created by pineone on 2021/09/02.
//

import UIKit

public typealias Color = UIColor

extension UIColor {
    convenience init(_ red: Int, _ green: Int, _ blue: Int) {
        let newRed = CGFloat(red)/255
        let newGreen = CGFloat(green)/255
        let newBlue = CGFloat(blue)/255
        
        self.init(red: newRed, green: newGreen, blue: newBlue, alpha: 1.0)
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: CGFloat((rgb >> 16) & 0xFF) / 255,
            green: CGFloat((rgb >> 8) & 0xFF) / 255,
            blue: CGFloat(rgb & 0xFF) / 255,
            alpha: 1.0)
    }
    
    convenience init(argb: Int) {
        self.init(
            red: CGFloat((argb >> 16) & 0xFF) / 255,
            green: CGFloat((argb >> 8) & 0xFF) / 255,
            blue: CGFloat(argb & 0xFF) / 255,
            alpha: CGFloat((argb >> 24) & 0xFF) / 255)
    }
    
    convenience init(argb: String) {
        var cString:String = argb.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }

        if ((cString.count) == 6) {
            cString = "ff"+cString
        } else if ((cString.count) != 8) {
            cString = "ffffffff"
        }

        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)
        self.init(
            red: CGFloat((rgbValue & 0x00FF0000) >> 16) / 255,
            green: CGFloat((rgbValue & 0x0000FF00) >> 8) / 255,
            blue: CGFloat(rgbValue & 0x000000FF) / 255,
            alpha: CGFloat((rgbValue & 0xFF000000) >> 24) / 255
        )
    }
}

extension Int {
    public var color: Color {
        let red = CGFloat(self as Int >> 16 & 0xff) / 255
        let green = CGFloat(self >> 8 & 0xff) / 255
        let blue = CGFloat(self & 0xff) / 255
        return Color(red: red, green: green, blue: blue, alpha: 1)
    }

    public var cgColor: CGColor {
        let red = CGFloat(self as Int >> 16 & 0xff) / 255
        let green = CGFloat(self >> 8 & 0xff) / 255
        let blue = CGFloat(self & 0xff) / 255
        return CGColor(srgbRed: red, green: green, blue: blue, alpha: 1)
    }
}

precedencegroup AlphaPrecedence {
    associativity: left
    higherThan: RangeFormationPrecedence
    lowerThan: AdditionPrecedence
}

infix operator ~ : AlphaPrecedence

public func ~ (color: Color, alpha: Int) -> Color {
    return color ~ CGFloat(alpha)
}

public func ~ (color: Color, alpha: Float) -> Color {
    return color ~ CGFloat(alpha)
}

public func ~ (color: Color, alpha: CGFloat) -> Color {
    return color.withAlphaComponent(alpha)
}

/// e.g. `50%`
postfix operator %
public postfix func % (percent: Int) -> CGFloat {
    return CGFloat(percent)%
}

public postfix func % (percent: Float) -> CGFloat {
    return CGFloat(percent)%
}

public postfix func % (percent: CGFloat) -> CGFloat {
    return percent / 100
}

