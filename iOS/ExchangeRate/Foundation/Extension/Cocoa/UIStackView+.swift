//
//  UIStackView+.swift
//  Base
//
//  Created by pineone on 2021/09/02.
//

import SnapKit
import Then
import UIKit

extension UIStackView {
    func removeArrangedSubviewCompletely(_ subview: UIView) {
        removeArrangedSubview(subview)
        subview.removeFromSuperview()
    }

    func removeAllArrangedSubviewsCompletely() {
        for subview in arrangedSubviews.reversed() {
            removeArrangedSubviewCompletely(subview)
        }
    }

    func removeArrangedSubviewsCompletely(_ subviews: [UIView]) {
        for subview in subviews {
            removeArrangedSubviewCompletely(subview)
        }
    }

    func addArrangedSubviews(_ subviews: [UIView]) {
        for subview in subviews {
            addArrangedSubview(subview)
        }
    }
}

extension UIStackView {
    static func `default`(axis: NSLayoutConstraint.Axis) -> UIStackView {
        return UIStackView().then {
            $0.distribution = .fillEqually
            $0.alignment = .fill
            $0.axis = axis
            $0.spacing = 1
            $0.translatesAutoresizingMaskIntoConstraints = false

//            $0.customSpacing(after: UIView().then {
//                $0.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
//            })
        }
    }

    func setBackgroundColor(color: UIColor) {
        let backgroundView = UIView().then {
                   $0.backgroundColor = color
        }

        self.insertSubview(backgroundView, at: 0)

        backgroundView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
