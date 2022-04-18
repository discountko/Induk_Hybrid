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

enum LoginActionType {
    case goHome
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
        case .goHome:
            self.steps.accept(MainSteps.home)
            //break;
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
    
    
}
