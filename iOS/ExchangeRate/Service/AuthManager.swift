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

// https://firebase.google.com/docs/auth/ios/start

class AuthManager {
    static let current = AuthManager()
    
    var disposeBag = DisposeBag()
    
    static var USER_NAME = ""
    
    var state = PublishRelay<AuthStateDidChangeListenerHandle>()
    
    var user: User? = Auth.auth().currentUser
    
    var isLogined: Bool = Auth.auth().currentUser != nil ? true : false
    
    let handle = Auth.auth().then {
        $0.useAppLanguage()
        $0.languageCode = "kr"
    }
    
    private func autoLogin() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(checkAutoLogin), name: .AuthState, object: nil)
    }
    
    
    @objc
    func checkAutoLogin() {
        
    }
    
    /// 이메일 회원가입
    func signUp(withEmail email: String, password pwd: String, result: @escaping((AuthDataResult?, Error?) -> Void)) -> (AuthDataResult?, Error?) {
        var result: (AuthDataResult?, Error?) = (nil, nil)
        
        //handle.createUser(withEmail: <#T##String#>, password: <#T##String#>)
        
        // (AuthDataResult?, Error?)
        handle.createUser(withEmail: email, password: pwd) { authDataResult, error in
            result = (authDataResult, error)
        }
        
        return result
    }
    
    /// 이메일 로그인
    func signIn(withEmail email: String, password pwd: String, result: @escaping((AuthDataResult?, Error?) -> Void)) -> Void {
        var result: (AuthDataResult?, Error?) = (nil, nil)
        
        handle.signIn(withEmail: email, password: pwd) { authDataResult, error in
            result = (authDataResult, error)
        }
        
    }
    
    func updatePassword(to password: String, result: @escaping((Error?) -> Void)) {
        var result: Error? = nil
        
        user?.updatePassword(to: password, completion: { error in
            result = error
        })
    }
    
    // 인증 상태 수신 대기
    func authState() {
        // (Auth, User?)
        let authListner = handle.addStateDidChangeListener { auth, user in
            Log.d("result : \(auth), \(user)")
        }
        
        state.accept(authListner)
    }
    
    func removeState() {
       handle.removeStateDidChangeListener(handle)
    }
    
    func subscribeState() {
        state.subscribe(onNext: { [weak self] in
            guard let `self` = self else { return }
            self.handle.removeStateDidChangeListener($0)
        }).disposed(by: disposeBag)
    }
}


extension Notification.Name {
    static let AuthState = NSNotification.Name("authState")
}
