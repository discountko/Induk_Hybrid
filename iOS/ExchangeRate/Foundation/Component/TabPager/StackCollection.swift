//
//  StackCollection.swift
//  Basic
//
//  Created by pineone on 2021/12/16.
//

import RxCocoa
import RxSwift
import UIKit

protocol SCDelegate: NSObject {
    func stackCollection(_ sc: StackCollection, didSelectItemAt item: Int)
}

class StackCollection: UIStackView {
    weak var delegate: SCDelegate?

    var views: [TabPagerHeaderView]?

    // layoutSetting

    // useModels make buttons then add view
    func addArrangedSubviews(models: [TabPagerHeaderCellModel], force: Bool = false) {
//        if force {
        views?.forEach {
            $0.removeFromSuperview()
        }
        views = nil
        //        }
//        guard views == nil else { return }

        let views = models.map { $0() }
        self.views = views
        super.addArrangedSubviews(views)

        let tapAction = PublishRelay<Int>()

        tapAction.throttle(.milliseconds(500), scheduler: MainScheduler.asyncInstance)
            .on(next: selectItem(at:))
            .disposed(by: rx.disposeBag)

        for (index, headerCellView) in views.enumerated() {
            headerCellView.setupDI(index: index, actionRelay: tapAction)
        }
    }

    func reloadData(at index: Int = 0) {
        self.views?.forEach {
            $0.title.isSelected = false
        }

        if let views = self.views, let view = views.get(index) {
            viewReload()
            view.title.isSelected = true
        }
    }

    func viewReload() {
        self.views?.forEach {
            $0.cellset($0.data)
        }
    }

    func selectItem(at index: Int?) {
        if let index = index {
            reloadData(at: index)
            delegate?.stackCollection(self, didSelectItemAt: index)
        }
    }
}
