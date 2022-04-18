//
//  CollectionView+Rx.swift
//  AISAR
//
//  Created by baedy on 2020/11/05.
//  Copyright © 2020 Pineone. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

extension Reactive where Base: UICollectionView {
    var indexPathsForSelectedItems: Observable<[IndexPath]> {
        let itemSelected = delegate
            .methodInvoked(#selector(UICollectionViewDelegate.collectionView(_:didSelectItemAt:)))
        let itemDeselected = delegate
            .methodInvoked(#selector(UICollectionViewDelegate.collectionView(_:didDeselectItemAt:)))

        let items = Observable.of(itemSelected, itemDeselected)
            .merge()
            .flatMap { Observable.just($0[0] as! UICollectionView) }
            .flatMap { Observable.just($0.indexPathsForSelectedItems ?? []) }

        let allSelect = allSelectInvoke
        .flatMap { Observable.just($0.indexPathsForSelectedItems ?? []) }
            .share()

        let allDeSelect = allDeSelectInvoke
         .flatMap { Observable.just($0.indexPathsForSelectedItems ?? []) }
            .share()

//            .flatMap { _ -> Observable<[IndexPath]> in Observable.just([]) }

        return Observable.merge(items, allSelect, allDeSelect)
    }

    var allSelectInvoke: Observable<UICollectionView> {
        let allSelect = methodInvoked(#selector(base.selectItemAll(animated:scrollPosition:)))

        return Observable.create { observer in
            let allSelectDisposable = allSelect.subscribe(onNext: { _ in
                DispatchQueue.main.async {
                    observer.on(.next((self.base)))
                }
            })
            return Disposables.create([allSelectDisposable])
        }
    }

    var allDeSelectInvoke: Observable<UICollectionView> {
        let allSelect = methodInvoked(#selector(base.deSelectItemAll(animated:)))

        return Observable.create { observer in
            let allDeSelectDisposable = allSelect.subscribe(onNext: { _ in
                DispatchQueue.main.async {
                    observer.on(.next((self.base)))
                }
            })
            return Disposables.create([allDeSelectDisposable])
        }
    }

    /// for just one section
    var isAllSelectItem: Observable<Bool> {
        base.rx.indexPathsForSelectedItems.map {
            let result = $0.count == self.base.numberOfItems(inSection: 0)
            Log.d(result)
            return result
        }
    }

    var indexPathForSelectedItem: Observable<IndexPath> {
        return delegate
            .methodInvoked(#selector(UICollectionViewDelegate.collectionView(_:didSelectItemAt:))).map { $0[1] as! IndexPath }
    }

    var selectedIndexPath: Binder<IndexPath> {
        return Binder(base) { collectionView, indexPath in
            collectionView.selectItem(at: indexPath, animated: false, scrollPosition: [])
        }
    }

    var willDisplayCell: ControlEvent<(cell: UICollectionViewCell, indexPath: IndexPath)> {
        let source: Observable<(cell: UICollectionViewCell, indexPath: IndexPath)> = self.delegate.methodInvoked(#selector(UICollectionViewDelegate.collectionView(_:willDisplay:forItemAt:)))
            .map { ($0[1] as! UICollectionViewCell, $0[2] as! IndexPath) }
        return ControlEvent(events: source)
    }

    var didEndDisplayCell: ControlEvent<(cell: UICollectionViewCell, indexPath: IndexPath)> {
        let source: Observable<(cell: UICollectionViewCell, indexPath: IndexPath)> = self.delegate.methodInvoked(#selector(UICollectionViewDelegate.collectionView(_:didEndDisplaying:forItemAt:)))
            .map { ($0[1] as! UICollectionViewCell, $0[2] as! IndexPath) }
        return ControlEvent(events: source)
    }

    var didChangeVisibleItems: Observable<[IndexPath]> {
        let willDisplayCellObservable = willDisplayCell.take(1)
        let didChangePageObservable = didChangePage
        return Observable.create { [base = base] observer in
            _ = willDisplayCellObservable.subscribe(onNext: { _, indexPath in
                observer.on(.next([indexPath]))
            })
            _ = didChangePageObservable.subscribe(onNext: { _ in
                observer.on(.next(base.indexPathsForVisibleItems))
            })
            return Disposables.create()
        }
    }

    var reloaded: Observable<()> {
        let reloadData = methodInvoked(#selector(base.reloadData))
        return Observable.create { observer in
            let reloadDataDisposable = reloadData.subscribe(onNext: { _ in
                DispatchQueue.main.async {
                    observer.on(.next(()))
                }
            })
            return Disposables.create([reloadDataDisposable])
        }
    }

    var multiSelectionObserable: Observable<Bool> {
        return self.observe(Bool.self, "allowsMultipleSelection").compactMap { $0 }
    }

    var allowMultipleSelection: RxCocoa.Binder<Bool> {
        return Binder(self.base) { _, selection in
            self.base.allowsMultipleSelection = selection
        }
    }

    var backgroundViewIsHidden: RxCocoa.Binder<Bool> {
        return Binder(self.base) { _, selection in
            self.base.backgroundView?.isHidden = selection
        }
    }

    var selectItems: Observable<[IndexPath]> {
        return delegate.methodInvoked(#selector(UICollectionViewDelegate.collectionView(_:didSelectItemAt:)))
            .map { _ in
                guard let items = self.base.indexPathsForSelectedItems else {
                    return []
                }
                return items
            }
    }
}
