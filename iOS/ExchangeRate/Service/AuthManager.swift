//
//  AuthManager.swift
//  ExchangeRate
//
//  Created by pineone on 2022/05/02.
//

import Action
import RxCocoa
import RxSwift
import UIKit
import Firebase

class AuthManager {
    static let current = AuthManager()
    
    var state = PublishRelay<AuthStateDidChangeListenerHandle>()
    
    let handle = Auth.auth()
    
    func test() {
        let tt = handle.addStateDidChangeListener { auth, user in
            
        }
    }
    
    func signIn(withEmail email: String?, password pwd: String) -> (AuthDataResult?, Error?) {
        return (nil, nil)
    }
    
//    Auth.auth().signIn(withEmail: id, password: pwd) { [weak self] authResult, error in
//        guard let `self` = self else { return }
//
//        if let result = authResult {
//            let info = (result.additionalUserInfo, result.user, result.credential, result.debugDescription)
//            Log.d("Result : \(info)")
//            self.steps.accept(MainSteps.home)
//        } else {
//            Log.e("Error : \(error?.localizedDescription)")
//            Log.e("TT : \(error.debugDescription)")
//
//
//            guard let errorInfo = error as? NSError else {
//                print("error Nil!!")
//                return
//            }
//            Log.e("ErrorCode \(errorInfo.code), Domain \(errorInfo.domain)")
//            Log.e("Test : \(errorInfo.userInfo["FIRAuthErrorUserInfoNameKey"])")
//        }
//    }
    
}
