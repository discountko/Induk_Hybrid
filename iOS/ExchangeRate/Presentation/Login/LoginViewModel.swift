//
//  LoginViewModel.swift
//  ExchangeRate
//
//  Created by pineone on 2022/04/18.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import RxFlow
import Action
import Firebase

enum LoginActionType {
    case goHome(String?, String?)
}

class LoginViewModel: ViewModelType, Stepper {
    // MARK: - Stepper
    var steps = PublishRelay<Step>()
    
    // MARK: - ViewModelType Protocol
    typealias ViewModel = LoginViewModel
    
    var disposeBag = DisposeBag()
    
    // TODO: - Deinit 개발 완료 한 뒤 메모리가 정상적으로 해제 되면 삭제!
    deinit {
        Log.d("로그 : \(self)!!")
    }
    
    // MARK: - Actions
    lazy var actionForNaviBar = Action<BaseNavigationActionType, Void> { [weak self] in
        guard let `self` = self else { return .empty() }
        switch $0 {
        case .back:
            self.steps.accept(MainSteps.popViewController)
        default: break
        }
        return .empty()
    }
    
    lazy var actionForButton = Action<LoginActionType, Void> { [weak self] in
        guard let `self` = self else { return .empty() }
        switch $0 {
        case .goHome (let email, let password):
            self.signIn(email, password: password)
            //self.steps.accept(MainSteps.home)
        default: break
        }
        return .empty()
    }
    
    struct Input {
        let naviBarTrigger: PublishRelay<BaseNavigationActionType>
        let actionTrigger: PublishRelay<LoginActionType>
    }
    
    struct Output {
    }
    
    func transform(req: ViewModel.Input) -> ViewModel.Output {
        req.naviBarTrigger.bind(to: actionForNaviBar.inputs).disposed(by: disposeBag)
        req.actionTrigger.bind(to: actionForButton.inputs).disposed(by: disposeBag)
        
        return Output()
    }
    
    func signIn(_ email: String?, password: String?) {
        /// 1. 이메일 비밀번호 빈값여부 체크해서 로그인 버튼 활성/비활성
        /// 2. 이메일 정규식
        ///
        /// 3. 이메일 만들기(회원가입)
        /// 4. 비밀번호 찾기
        /// 5. 이메일 문자인증
        ///
        /// 파베 아이디비번 : test12@naver.com // 123456
        /// 의문점.. 비번/패스워드 싱글톤 서비스 만들어야겠다..
        /// UserDefault에 저장해서 웹에 전송 해야 할 듯하다...
        
        guard let id = email, let pwd = password else {
            print("email 또는 패스워드 빈값")
            return
        }
        
        
        Auth.auth().signIn(withEmail: id, password: pwd) { [weak self] authResult, error in
            guard let `self` = self else { return }
            
            if let result = authResult {
                let info = (result.additionalUserInfo, result.user, result.credential, result.debugDescription)
                print(info)
            } else {
                print(error.debugDescription)
                
                guard let errorInfo = error as? NSError else {
                    print("error Nil!!")
                    return
                }
                
                print(errorInfo.code, errorInfo.domain)
                // Error Code 처리하기!!!
            }
        }
        
        
        
        
        
    }
    
}
