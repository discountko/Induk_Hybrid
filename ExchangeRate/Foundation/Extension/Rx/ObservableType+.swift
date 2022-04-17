//
//  ObservableType+.swift
//  AISAR
//
//  Created by baedy on 2020/11/03.
//  Copyright © 2020 Pineone. All rights reserved.
//

import Action
import Foundation
import RxCocoa
import RxSwift

extension ObservableType {
    @discardableResult
    func on() -> Disposable {
        return on(next: { _ in }, error: nil)
    }

    @discardableResult
    func on(next: @escaping (Self.Element) -> Void) -> Disposable {
        return on(next: next, error: nil)
    }

    @discardableResult
    func on(next: @escaping (Self.Element) -> Void, error errorHandler: ((Error?, ServerApiProvider.ResultCode?, String?) -> Void)? = nil) -> Disposable {
        return subscribe(
            onNext: next,
            onError: { error in
                if let actionError = error as? ActionError {
                    switch actionError {
                    case .notEnabled:
                        errorHandler?(error, nil, nil)
                    case .underlyingError(let error):
                        if let apiServerError = error as? ServerApiProvider.Error, case .failureResponse(let api, let code, let desc) = apiServerError {
                            if let errors = api.errors, errors.contains(code) {
                                errorHandler?(nil, code, desc)
                            }
                        }
                    }
                } else if let apiServerError = error as? ServerApiProvider.Error, case .failureResponse(let api, let code, let desc) = apiServerError {
                    if let errors = api.errors, errors.contains(code) {
                        errorHandler?(nil, code, desc)
                    }
                } else {
                    errorHandler?(error, nil, nil)
                }
            })
    }
}

extension ObservableType {
    func makeVoid() -> Observable<Void> {
        return .empty()
    }

    var void: Observable<Void> {
        return .empty()
    }
}
