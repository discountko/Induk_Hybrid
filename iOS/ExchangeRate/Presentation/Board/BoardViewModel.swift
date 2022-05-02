//
//  BoardViewModel.swift
//  Basic
//
//  Created by pineone on 2021/09/23.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import RxFlow
import Action
import Firebase

enum BoardActionType {
    case logout
    case writing
}

class BoardViewModel: ViewModelType, Stepper {
    // MARK: - Stepper
    var steps = PublishRelay<Step>()
    
    // MARK: - ViewModelType Protocol
    typealias ViewModel = BoardViewModel
    
    var disposeBag = DisposeBag()
    
    lazy var actionForNaviBar = Action<BaseNavigationActionType, Void> { [weak self] in
        guard let `self` = self else { return .empty() }
        switch $0 {
        case .logout:
            AppStepper.shared.steps.accept(MainSteps.initialization)
            // TODO: 웹뷰 로그아웃 주소 이동처리
            // https://firebase.google.com/docs/reference/swift/firebaseauth/api/reference/Classes/Auth
            // https://firebase.google.com/docs/auth/ios/start
            let fbAuth = Auth.auth()
            do {
                try fbAuth.signOut()
            } catch let error as NSError {
                Log.e("Error siging out : \(error)")
            }
            
            
            
        default: break
        }
        return .empty()
    }
    
    struct Input {
        let naviBarTrigger: PublishRelay<BaseNavigationActionType>
        let actionTrigger: PublishRelay<BoardActionType>
    }
    
    struct Output {
    }
    
    func transform(req: ViewModel.Input) -> ViewModel.Output {
        req.naviBarTrigger.bind(to: actionForNaviBar.inputs).disposed(by: disposeBag)
        return Output()
    }
}
