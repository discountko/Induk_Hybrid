//
//  NewsFlow.swift
//  Base
//
//  Created by pineone on 2021/09/16.
//

import RxCocoa
import RxFlow
import RxSwift
import UIKit

class NewsFlow: BaseFlow {
    override func navigate(to step: Step) -> FlowContributors {
        let superContributors = super.navigate(to: step)
        if !superContributors.isNone {
            return superContributors
        }
        
        guard let step = step as? MainSteps else { return .none }
        switch step {
        case .news:
            return navigateNewsScreen()
        case .login:
            return navigateLoginScreen()
        default:
            return .none
        }
    }
}

extension NewsFlow {
    func navigateNewsScreen() -> FlowContributors {
        return FlowSugar(viewModel: NewsViewModel())
            .presentable(NewsViewController.self)
            .oneStepPushBy(navigationController)
    }
    
    private func navigateLoginScreen() -> FlowContributors {
        return FlowSugar(viewModel: LoginViewModel())
            .presentable(LoginViewController.self)
            .oneStepPushBy(navigationController)
    }
}
