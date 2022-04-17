import UIKit

import RxCocoa
import RxSwift

extension Reactive where Base: UIButton {
    /// Reactive `TouchUpInside` then state toggling, return changed current control's `selected` value
    public var toggle: Observable<Bool> {
        controlEvent(.touchUpInside).asObservable()
            .do(onNext: { self.base.isSelected.toggle() })
            .map { self.base.isSelected }
//            .flatMap { Observable.just( self.base.isSelected ) }
    }

    public var selected: Observable<Bool> {
        controlEvent(.touchUpInside).asObservable()
            .map { self.base.isSelected }
    }
}
