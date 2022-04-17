//
//  UIImage+.swift
//  Base
//
//  Created by pineone on 2021/09/02.
//

import UIKit

extension UIImage {
    
    /// Color로 Image를 생성합니다.
    ///
    /// - Parameters:
    ///   - color: 컬러
    ///   - size: image 사이즈
    ///
    /// ```
    /// let blueImage = UIImage(color: #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1))
    /// ```
    ///
    convenience init(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.init(cgImage: (image?.cgImage!)!)
    }
}
