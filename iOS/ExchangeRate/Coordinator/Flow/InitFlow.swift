//
//  InitFlow.swift
//  Base
//
//  Created by pineone on 2021/08/04.
//

import RxFlow
import UIKit
import Then
import RxSwift
import RxCocoa

/// Init과 Main(Tab)을 분리하느냐... 아니면 합치느냐..
class InitFlow: Flow {
    var root: Presentable { return self.rootViewController }
    
    private lazy var rootViewController = BaseNavigationController()
    
    
    /// Init Sequence : NavigationVC
    ///     AppLaunch > Permission > Network, App Version, SupportDevice...
    ///     > Agree > (Auto)Login > .. > `MAIN_SEQUENCE`
    ///
    /// Main Sequence :  TabBar > NavigationVC
    ///     FirstTab > First_1 > First_2
    ///     SecondTab > Second_1 > Second_2
    ///     ThirdTab > Third_1 > Third_2
    
    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? MainSteps  else { return .none }
        
        switch step {
        case .initialization:
            return self.navigate(to: MainSteps.loginCheck)
        case .loginCheck:
            return rootSetIntro()
        case .emailSignUp:
            return navigateToMain()
        case .findPassword:
            return navigateToSignUp()
        case .popViewController:
            _ = rootViewController.popViewController(animated: true)
        default:
            return .none
        }
        return .none
    }
}

extension InitFlow {
    private func rootSetIntro() -> FlowContributors {
        let sugar = FlowSugar(viewModel: LoginViewModel())
            .presentable(LoginViewController.self)

        if let vc = sugar.getViewController() {
            rootViewController.pushViewController(vc, animated: true)
            return .one(flowContributor: .contribute(withNextPresentable: vc, withNextStepper: sugar.vm))
        }
        return .none
    }
    
    private func navigateToSignUp() -> FlowContributors {
        return FlowSugar(viewModel: SignUpViewModel())
            .presentable(SignUpViewController.self)
            .oneStepPushBy(rootViewController)
        
        /* 방법2. UIKit의 pushViewController 사용
        let sugar = FlowSugar(viewModel: SignUpViewModel())
            .presentable(SignUpViewController.self)
        rootViewController.pushViewController(sugar.vc!, animated: true)

        if let vc = sugar.getViewController() {
            return .one(flowContributor: .contribute(withNextPresentable: vc, withNextStepper: sugar.vm))
        }
        return .none
         */
    }
    
    /// 로그인 완료 후 메인으로 이동!!!
    private func navigateToMain() -> FlowContributors {
        let mainFlow = MainFlow()
        
        Flows.use(mainFlow, when: .created) { [weak self] root in
            guard let `self` = self else { return }
            self.rootViewController.pushViewController(root, animated: true)
        }
        
        return .one(flowContributor: .contribute(withNextPresentable: mainFlow, withNextStepper: OneStepper(withSingleStep: MainSteps.moveToMain)))
    }
}
