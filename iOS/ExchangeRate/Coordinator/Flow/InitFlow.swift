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
import Firebase

/*
 메모리 해제가 정상적으로 되지 않는다..!!
 로그인 -> 회원가입 -> 로그인
 로그인 -> 로그아웃 -> 로그인
 */
class InitFlow: Flow {
    var root: Presentable { return self.rootViewController }
    
    private lazy var rootViewController = BaseTabBarController.shared
    
    let disposeBag = DisposeBag()
    
    let homeFlow = ExchangeFlow()
    let boardFlow = BoardFlow()
    let newsFlow = NewsFlow()
    
    var tabBarTitle: [String] {
        return ["환율전환", "채팅", "뉴스"]
    }
    
    var sfSymbols = ["person.crop.circle", "person.crop.circle.fill",
                     "house.circle", "house.circle.fill",
                     "newspaper.circle", "newspaper.circle.fill"]
    
    var tabBarImage: [UIImage] {
        return [UIImage(systemName: sfSymbols[0])!, UIImage(systemName: sfSymbols[2])!, UIImage(systemName: sfSymbols[4])!]
        
    }
    var tabBarImageS: [UIImage] {
        return [UIImage(systemName: sfSymbols[1])!, UIImage(systemName: sfSymbols[3])!, UIImage(systemName: sfSymbols[5])!]
    }

    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? MainSteps  else { return .none }
        
        switch step {
        case .initialization:
            return self.navigate(to: MainSteps.loginCheck)
        case .loginCheck:
            //return AuthManager.current.isLogined ? moveToHome() : rootSetIntro()
            return rootSetIntro()
        case .emailSignUp:
            return navigateToEmailSignUp()
        case .moveToMain:
            return moveToHome()
        case .moveTab(let index):
            rootViewController.selectTabBarWith(index: index)
            return .none
        case .backToLogin:
            return .end(forwardToParentFlowWithStep: MainSteps.initialization)
        default:
            return .none
        }
    }
}

extension InitFlow {
    private func rootSetIntro() -> FlowContributors {
        let sugar = FlowSugar(viewModel: LoginViewModel())
            .presentable(LoginViewController.self)

        if let vc = sugar.getViewController() {
            rootViewController.tabBar.isHidden = true
            rootViewController.setViewControllers([vc], animated: true)
            return .one(flowContributor: .contribute(withNextPresentable: vc, withNextStepper: sugar.vm))
        }
        return .none
    }
    
    private func navigateToEmailSignUp() -> FlowContributors {
        let sugar = FlowSugar(viewModel: SignUpViewModel())
            .presentable(SignUpViewController.self)
//            .oneStepModalPresentMakeNavi(rootViewController, .automatic)
//        return sugar
        
        if let vc = sugar.getViewController() {
            rootViewController.setViewControllers([vc], animated: true)
            return .one(flowContributor: .contribute(withNextPresentable: vc, withNextStepper: sugar.vm))
        }
        return .none
    }
    
    private func moveToHome() -> FlowContributors {
        // 탭바 초기 설정
        let flows: [Flow] = [homeFlow, boardFlow, newsFlow]
        
        Flows.use(flows, when: .created) { [unowned self] (roots: [BaseNavigationController]) in
            for(index, root) in roots.enumerated() {
                Log.d("index = \(index), root = \(root)")
                root.tabBarItem = UITabBarItem(title: tabBarTitle[index],
                                               image: tabBarImage[index].withTintColor(.black).withRenderingMode(.alwaysOriginal),
                                               selectedImage: tabBarImageS[index].withTintColor(.black).withRenderingMode(.alwaysOriginal))
                root.tabBarItem.imageInsets = UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0)
                root.tabBarItem.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 0)
            }
            
            UITabBarItem.setupBarItem()
            
            self.rootViewController.tabBar.isHidden = false
            self.rootViewController.setViewControllers(roots, animated: true)
        }
        
        return .multiple(flowContributors: [
            .contribute(withNextPresentable: homeFlow, withNextStepper: ExchangeStepper.shared),
            .contribute(withNextPresentable: boardFlow, withNextStepper: BoardStepper.shared),
            .contribute(withNextPresentable: newsFlow, withNextStepper: NewsStepper.shared)
        ])
    }
}
