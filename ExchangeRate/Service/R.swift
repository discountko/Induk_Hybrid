//
//  R.swift
//  Basic
//
//  Created by pineone on 2021/12/13.
//

import UIKit

struct R {
    struct Color {
        struct Base {}
    }
    
    struct String {
        struct Home {}
    }
    
    struct Image {
        struct Navi {}
    }
}

extension R.Image.Navi {
    static let btnCommonBefore = UIImage(named: "BtnCommonBefore")
    static let btnClose = UIImage(named: "btnClose")
    static let btnCommonSettingsNor = UIImage(named: "btnCommonSettingsNor")
    static let btnCommonMoreNor = UIImage(named: "btnCommonMoreNor")
    static let delNor = UIImage(named: "delNor")
}

extension R.Color {
    /// #00000, rgb 0 0 0
    static let white_1000 = UIColor(named: "white_1000")
    static let white_1005 = UIColor(named: "white_1005")
    /// #3DACF7,rgb 61 172 247
    static let blue = UIColor(61, 172, 247)
    /// #000000,rgb 0 0 0
    static let black = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    /// #1D1C21, rgb 29 28 33
    static let background = #colorLiteral(red: 0.1137254902, green: 0.1098039216, blue: 0.1294117647, alpha: 1)
}

extension R.Color.Base {
    static let input_field_bg = #colorLiteral(red: 0.8862745098, green: 0.8862745098, blue: 0.9019607843, alpha: 0.8)
    static let mode_case_unselected = #colorLiteral(red: 0.9647058824, green: 0.968627451, blue: 0.9725490196, alpha: 1)
    /// #60398E, RGB 96 57 142
    static let mode_case_selected = #colorLiteral(red: 0.3764705882, green: 0.2235294118, blue: 0.5568627451, alpha: 1)
    /// #949495, RGB 148 148 149
    static let tab_num_unselected = #colorLiteral(red: 0.5803921569, green: 0.5803921569, blue: 0.5843137255, alpha: 1)
    /// #E2E3E6, RGBA 226 227 230 0.3
    static let tab_backgroundColor =  #colorLiteral(red: 0.8862745098, green: 0.8901960784, blue: 0.9019607843, alpha: 0.3)
}
