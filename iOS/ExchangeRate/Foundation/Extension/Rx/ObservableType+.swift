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
import Firebase

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
    
//    @discardableResult
//    func on(next: @escaping (Self.Element) -> Void, error errorHandler: ((Error?) -> Void)? = nil) -> Disposable {
//        return subscribe(
//            onNext: next,
//            onError: { error in
//                if let actionError = error as? ActionError {
//                    switch actionError {
//                    case .notEnabled:
//                        errorHandler?(error)
//                    case .underlyingError(let error):
//                        if let errorInfo = error as? NSError {
//                            
//                            
//                            Log.e("ErrorCode \(errorInfo.code), Domain \(errorInfo.domain)")
//                            Log.e("Error Info : \(errorInfo.userInfo["FIRAuthErrorUserInfoNameKey"])")
//                        }
//                    }
//                } else if let e = error as? NSError {
//                    errorHandler?(e)
//                    
//                    Log.e("ErrorCode 222 \(e.code), Domain \(e.domain)")
//                    Log.e("Error Info : \(e.userInfo["FIRAuthErrorUserInfoNameKey"])")
//                }
//            }
//        )
}

extension ObservableType {
    func makeVoid() -> Observable<Void> {
        return .empty()
    }

    var void: Observable<Void> {
        return .empty()
    }
}
