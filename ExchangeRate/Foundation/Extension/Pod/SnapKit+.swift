//
//  SnapKit+.swift
//  Basic
//
//  Created by pineone on 2021/11/05.
//

import SnapKit
import UIKit

extension ConstraintMakerRelatable {
    @discardableResult
    public func equalToSafeAreaAuto(_ view: UIView, _ file: String = #file, _ line: UInt = #line) -> ConstraintMakerEditable {
        if #available(iOS 11.0, *) {
            return self.equalTo(view.safeAreaLayoutGuide, file, line)
        }
        return self.equalToSuperview()
    }
}
