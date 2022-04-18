//
//  UIScrollView+.swift
//  Base
//
//  Created by pineone on 2021/09/02.
//

import UIKit

extension UIScrollView {
    func isNearBottomEdge(edgeOffset: CGFloat = 20.0) -> Bool {
        return self.contentOffset.y + self.frame.size.height + edgeOffset > self.contentSize.height
    }

    func isNearTrailingEdge(edgeOffset: CGFloat = 20.0) -> Bool {
        Log.d("isNearTrailingEdge()")
        let result = self.contentOffset.x + self.frame.size.width + edgeOffset > self.contentSize.width
        Log.d("isNearTrailingEdge(): \(result)")
        return result
    }

    func scrollToBottom(extraHeight: CGFloat? = 0) {
        let bottomOffset = CGPoint(x: 0, y: contentSize.height - bounds.size.height + contentInset.bottom + (extraHeight ?? 0))
        if bottomOffset.y > 0 {
            setContentOffset(bottomOffset, animated: true)
        }
    }

    func scrollToView(view: UIView, extraHeight: CGFloat? = 0) {
        if let origin = view.superview {
            let viewStartPoint = origin.convert(view.frame.origin, to: self)
            let bottomOffset = CGPoint(x: 0, y: contentSize.height - bounds.size.height + contentInset.bottom + (extraHeight ?? 0))

            if viewStartPoint.y > bottomOffset.y {
                setContentOffset(bottomOffset, animated: true)
            } else {
                setContentOffset(CGPoint(x: 0, y: viewStartPoint.y), animated: true)
            }
        }
    }
}
