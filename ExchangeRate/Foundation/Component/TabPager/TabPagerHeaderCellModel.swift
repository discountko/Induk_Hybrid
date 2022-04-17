//
//  TabPagerHeaderCellModel.swift
//  Basic
//
//  Created by pineone on 2021/12/16.
//

import UIKit

public struct TabPagerHeaderCellModel {
    var title: String
    var selectedFont: UIFont?
    var deSelectedFont: UIFont?

    var titleSelectedColor: UIColor?
    var titleDeSelectedColor: UIColor?

    let indicatorColor: UIColor? = nil
    var indicatorHeight: CGFloat? = nil
    var displayNewIcon: Bool?
    var iconImage: UIImage?
    var iconSelectedImage: UIImage?
    var iconHighlightedImage: UIImage?
    var indicatorPadding: CGFloat? = nil
    var iconEdgeInset: UIEdgeInsets? = nil
    
    func callAsFunction() -> TabPagerHeaderView {
        TabPagerHeaderView().then {
            $0.cellset(self)
            $0.data = self
        }
    }
}

class TabPagerHeaderDefault {
    static let indicatorHeight: CGFloat = 2.0
    static let indicatorColor: UIColor = #colorLiteral(red: 0.3411764706, green: 0.2156862745, blue: 0.8392156863, alpha: 1) //R.Color.base
    static let selectedFont = UIFont.notoSans(.bold, size: 16)
    static let selectedColor: UIColor = #colorLiteral(red: 0.3411764706, green: 0.2156862745, blue: 0.8392156863, alpha: 1) //R.Color.black
    static let deSelectedFont = UIFont.notoSans(.bold, size: 16)
    static let deSelectedColor: UIColor = R.Color.black ~ 20%
}
