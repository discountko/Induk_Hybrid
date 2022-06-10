//
//  UIScrollView+Rx.swift
//  AISAR
//
//  Created by baedy on 2020/11/05.
//  Copyright © 2020 Pineone. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

extension Reactive where Base: UIScrollView {
    var didChangePage: ControlEvent<Int> {
        let scrollView = base
        let source = Observable.of(didEndDecelerating, didEndScrollingAnimation)
            .merge()
            .map { () -> Int in
                guard scrollView.isPagingEnabled else {
                    return 0
                }
                return Int(scrollView.contentOffset.x / scrollView.bounds.width)
            }
            .distinctUntilChanged()
        return ControlEvent(events: source)
    }

    var contentSize: Observable<CGSize> {
        return observe(CGSize.self, "contentSize").filter { $0 != nil }.map { $0! }
    }
}
