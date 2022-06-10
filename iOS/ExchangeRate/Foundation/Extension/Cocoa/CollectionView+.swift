//
//  CollectionView+.swift
//  Base
//
//  Created by pineone on 2021/09/14.
//

import RxCocoa
import RxSwift
import UIKit

extension UICollectionView {

    // "selectItem/deselectItem" 호출시, 사용자가 선택한것과 다르게 관련 delegate methods가 호출되지 않는다.
    // 그래서 명시적으로 호출하는 extension을 추가하였다!
    func selectItemAndCallDelegateMethod(at indexPath: IndexPath?, animated: Bool, scrollPosition: UICollectionView.ScrollPosition) {
        self.selectItem(at: indexPath, animated: animated, scrollPosition: scrollPosition)
        if let indexPath = indexPath {
            self.delegate?.collectionView?(self, didSelectItemAt: indexPath)
        }
    }
    func deselectItemAndCallDelegateMethod(at indexPath: IndexPath, animated: Bool) {
        self.deselectItem(at: indexPath, animated: animated)
        self.delegate?.collectionView?(self, didDeselectItemAt: indexPath)
    }
    
    @objc func selectItemAll(animated: Bool, scrollPosition: ScrollPosition) {
        (0..<self.numberOfSections).forEach { section in
            (0..<self.numberOfItems(inSection: section)).forEach { item in
                self.selectItem(at: IndexPath(item: item, section: section), animated: animated, scrollPosition: scrollPosition)
            }
        }
    }

    @objc func deSelectItemAll(animated: Bool) {
        (0..<self.numberOfSections).forEach { section in
            (0..<self.numberOfItems(inSection: section)).forEach { item in
                self.deselectItem(at: IndexPath(item: item, section: section), animated: animated)
            }
        }
    }

    func scrollToTop(animated: Bool = true) {
        DispatchQueue.main.asyncAfter(deadline: .now()) { [weak self] in
            let point = CGPoint(x: 0, y: 0)
            self?.setContentOffset(point, animated: animated)
        }
    }
}

