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
        struct Main {}
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

extension R.String {
    /// edit warning toast message
    static let forbiddenForSpace = "띄어쓰기는 입력 하실 수 없습니다."
    static let forbiddenForNumber = "숫자는 입력 하실 수 없습니다."
    static let forbiddenForKorean = "한글은 입력 하실 수 없습니다."
    static let forbiddenForEnglish = "영어는 입력 하실 수 없습니다."
    static let forbiddenForSpecialCharacter = "특수문자는 입력 하실 수 없습니다."
    static let forbiddenForEmoji = "이모지는 입력 하실 수 없습니다."
    static let forbiddenForSNSLinkUrl = "유효하지 않은 주소입니다."
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
    
    /// #7853FF, rgb 120 83 255
    static let purple =  #colorLiteral(red: 0.4705882353, green: 0.3254901961, blue: 1, alpha: 1)
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

extension R.Color.Main {
    /// #000000, rgb 0 0 0 Opacity 30%
    static let textOpac30 = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.3)
    /// #000000, rgb 0 0 0 Opacity 40%
    static let textOpac40 = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.4)
    /// #000000, rgb 0 0 0 Opacity 50%
    static let textOpac50 = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5)
    /// #000000, rgb 0 0 0 Opacity 70%
    static let textOpac70 = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.7)
    /// #FFFFFF, rgb 255 255 255 Opacity 70%
    static let placeholderOpac70 = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.7)
    /// #222222, rgb 34 34 34
    static let text34 = #colorLiteral(red: 0.1333333333, green: 0.1333333333, blue: 0.1333333333, alpha: 1)
    /// #4F4F4F, rgb 79 79 79
    static let text79 = #colorLiteral(red: 0.3098039216, green: 0.3098039216, blue: 0.3098039216, alpha: 1)
    /// #969696, rgb 150 150 150
    static let text150 = #colorLiteral(red: 0.5882352941, green: 0.5882352941, blue: 0.5882352941, alpha: 1)
    /// #D7D7D7, rgb 215 215 215
    static let thumbnailBG = #colorLiteral(red: 0.8431372549, green: 0.8431372549, blue: 0.8431372549, alpha: 1)
    /// #F6F6F6, rgb 246 246 246
    static let backround246 = #colorLiteral(red: 0.9647058824, green: 0.9647058824, blue: 0.9647058824, alpha: 1)
    /// #EAEAEA, rgb 234 234 234
    static let border234 = #colorLiteral(red: 0.9176470588, green: 0.9176470588, blue: 0.9176470588, alpha: 1)
}
