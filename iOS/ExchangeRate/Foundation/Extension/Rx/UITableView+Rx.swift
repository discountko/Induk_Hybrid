//
//  UITableView+Rx.swift
//  AISAR
//
//  Created by 허광호 on 2020/11/06.
//  Copyright © 2020 Pineone. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

extension Reactive where Base: UITableView {
    var indexPathsForSelectedItems: Observable<[IndexPath]> {
        let itemSelected = delegate.methodInvoked(#selector(UITableViewDelegate.tableView(_:didSelectRowAt:)))
        let itemDeselected = delegate.methodInvoked(#selector(UITableViewDelegate.tableView(_:didDeselectRowAt:)))

        let items = Observable.of(itemSelected, itemDeselected)
            .merge()
            .flatMap { Observable.just($0[0] as! UITableView) }
            .flatMap { Observable.just($0.indexPathsForSelectedRows ?? []) }

        let allSelect = allSelectInvoke
            .flatMap { Observable.just($0.indexPathsForSelectedRows ?? []) }
            .share()

        let allDeSelect = allDeSelectInvoke
            .flatMap { Observable.just($0.indexPathsForSelectedRows ?? []) }
            .share()

        return Observable.merge(items, allSelect, allDeSelect)
    }

    var allSelectInvoke: Observable<UITableView> {
        let allSelect = methodInvoked(#selector(base.selectRowAll(animated:scrollPosition:)))

        return Observable.create { observer in
            let allSelecDisposable = allSelect.subscribe(onNext: { _ in
                DispatchQueue.main.async {
                    observer.on(.next(self.base))
                }
            })
            return Disposables.create([allSelecDisposable])
        }
    }

    var allDeSelectInvoke: Observable<UITableView> {
        let allSelect = methodInvoked(#selector(base.deSelectRowAll(animated:)))

        return Observable.create { observer in
            let allDeSelecDisposable = allSelect.subscribe(onNext: { _ in
                DispatchQueue.main.async {
                    observer.on(.next(self.base))
                }
            })
            return Disposables.create([allDeSelecDisposable])
        }
    }

    var reloaded: Observable<()> {
        let reloadData = sentMessage(#selector(base.reloadData))
        return Observable.create { observer in
            let reloadDataDisposable = reloadData.subscribe(onNext: { _ in
                DispatchQueue.main.async {
                    observer.on(.next(()))
                }
            })
            return Disposables.create([reloadDataDisposable])
        }
    }

    /// for just one section
    var isAllSelectItem: Observable<Bool> {
        base.rx.indexPathsForSelectedItems.map {
            let result = $0.count == self.base.numberOfRows(inSection: 0)
            Log.d(result)
            return result
        }
    }

    var selectedIndexPath: Binder<[IndexPath]> {
        return Binder(base) { tableView, indexPaths in
            indexPaths.forEach {
                tableView.selectRow(at: $0, animated: false, scrollPosition: .none)
            }
        }
    }

    var multiSelectionObservable: Observable<Bool> {
        return self.observe(Bool.self, "allowsMultipleSelection").compactMap { $0 }
    }

    var allowMultipleSelection: RxCocoa.Binder<Bool> {
        return Binder(self.base) { _, selection in
            self.base.allowsMultipleSelection = selection
        }
    }
}
