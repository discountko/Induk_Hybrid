//
//  TableView+.swift
//  Base
//
//  Created by pineone on 2021/09/02.
//

import RxCocoa
import RxSwift
import UIKit

extension UITableView {
    @objc func selectRowAll(animated: Bool, scrollPosition: ScrollPosition) {
        (0 ..< self.numberOfSections).forEach { section in
            (0 ..< self.numberOfRows(inSection: section)).forEach { item in
                self.selectRow(at: IndexPath(item: item, section: section), animated: animated, scrollPosition: scrollPosition)
            }
        }
    }

    @objc func deSelectRowAll(animated: Bool) {
        (0..<self.numberOfSections).forEach { section in
            (0..<self.numberOfRows(inSection: section)).forEach { item in
                self.deselectRow(at: IndexPath(item: item, section: section), animated: animated)
            }
        }
    }
}
