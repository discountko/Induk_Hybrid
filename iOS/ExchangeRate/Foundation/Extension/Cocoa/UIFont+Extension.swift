//
//  UIFont+Extension.swift
//  Jump
//
//  Created by 홍기탁 on 2021/04/21.
//

import Foundation
import UIKit

extension UIFont {
    enum Style: String {
        /// 폰트 OTF 파일 이름이 아니라 PostScript 이름으로 명시해야 함. FontFamily 검색하면 확인 가능 (Mac 서체 관리자에서도 확인 가능)
//        case regular = "NotoSansCJKkr-Regular"
//        case medium = "NotoSansCJKkr-Medium"
//        case bold = "NotoSansCJKkr-Bold"
        case regular = "NotoSansKR-Regular"
        case medium = "NotoSansKR-Medium"
        case bold = "NotoSansKR-Bold"
    }

    var heightWithoutPadding: CGFloat { ascender - descender }
    
    public func textWidth(_ text: String?) -> CGFloat {
        if let width = text?.size(withAttributes: [NSAttributedString.Key.font: self]).width {
            return width
        }
        return 0
    }

    static func notoSans(_ style: Style = .regular, size: CGFloat) -> UIFont {
        return UIFont(name: style.rawValue, size: size)!
    }

    static func notoSans(size: CGFloat, weight: Style) -> UIFont {
        return UIFont(name: weight.rawValue, size: size)!
    }
}
