//
//  SignUpViewModel.swift
//  ExchangeRate
//
//  Created by pineone on 2022/05/02.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import RxFlow
import Action
import Firebase

enum SignUpActionType {
    case signUp(String?, String?)
}

class SignUpViewModel: ViewModelType, Stepper {
    // MARK: - Stepper
    var steps = PublishRelay<Step>()
    
    // MARK: - ViewModelType Protocol
    typealias ViewModel = SignUpViewModel
    
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
            self.steps.accept(MainSteps.backToLogin)
            self.steps.accept(MainSteps.initialization)
        default: break
        }
        return .empty()
    }
    
    lazy var actionForButton = Action<SignUpActionType, Void> { [weak self] in
        guard let `self` = self else { return .empty() }
        switch $0 {
        case .signUp(let id, let pwd):
            guard let id = id else { Toast.show("이메일을 입력해주세요."); return .empty() }
            guard let pwd = pwd else { Toast.show("패스워드를 입력해주세요."); return .empty() }
            
            AuthManager.current.signUp(withEmail: id, password: pwd) { authDataResult, error in
                if let result = authDataResult {
                    self.steps.accept(MainSteps.backToLogin)
                    self.steps.accept(MainSteps.initialization)
                } else {
                    Toast.show(error?.localizedDescription ?? "Error")
                }
            }
        }
        return .empty()
    }
    
    struct Input {
        let naviBarTrigger: PublishRelay<BaseNavigationActionType>
        let actionTrigger: PublishRelay<SignUpActionType>
    }
    
    struct Output {
    }
    
    func transform(req: ViewModel.Input) -> ViewModel.Output {
        req.naviBarTrigger.bind(to: actionForNaviBar.inputs).disposed(by: disposeBag)
        req.actionTrigger.bind(to: actionForButton.inputs).disposed(by: disposeBag)
        
        return Output()
    }
    
    
}
