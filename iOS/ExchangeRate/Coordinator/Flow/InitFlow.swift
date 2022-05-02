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
    
    private lazy var rootViewController = BaseTabBarController.shared
    
    let disposeBag = DisposeBag()
    
    let homeFlow = ExchangeFlow()
    let boardFlow = BoardFlow()
    let newsFlow = NewsFlow()
    
    var tabBarTitle: [String] {
        return ["환율전환", "게시판", "뉴스"]
    }
    
    var sfSymbols = ["person.crop.circle", "person.crop.circle.fill", "house.circle", "house.circle.fill", "newspaper.circle", "newspaper.circle.fill"]
    
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
            return rootSetIntro()
        case .emailSignUp:
            return moveToHome()
            //return navigateToEmailSignUp()
        case .findPassword:
            return moveToHome()
        case .home:
            return moveToHome()
        case .moveTab(let index):
            rootViewController.selectTabBarWith(index: index)
            return .none
            
        default:
            return .none
        }
    }
}

extension InitFlow {
    // FIXME: 네비게이션 고치기!!
    private func navigateToEmailSignUp() -> FlowContributors {
        if let topVC = UIApplication.shared.topViewController, topVC is LoginViewController {
            let naviVC = topVC as! UINavigationController
            
            return FlowSugar(viewModel: SignUpViewModel())
                .presentable(SignUpViewController.self)
                .oneStepPushBy(naviVC)
        } else {
            let topVC2 = UIApplication.shared.topViewController as? LoginViewController
            
            return FlowSugar(viewModel: SignUpViewModel())
                .presentable(SignUpViewController.self)
                .oneStepPushBy(topVC2!)
        }
        

        

    }
    
    
    private func checkLogin() -> FlowContributors {
        let sugar = FlowSugar(viewModel: LoginViewModel())
            .presentable(LoginViewController.self)
        
        if let vc = sugar.getViewController() {
            rootViewController.tabBar.isHidden = true
        }
        return .none
    }
    
    
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
