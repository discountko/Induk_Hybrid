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
            return self.navigate(to: MainSteps.home)

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
    
    private func rootSetIntro() -> FlowContributors {
        let sugar = FlowSugar(viewModel: ExchangeViewModel())
            .presentable(ExchangeViewController.self)

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

        Flows.use(flows, when: .created) {[unowned self] (roots: [BaseNavigationController]) in
            for(index, root) in roots.enumerated() {
                Log.d("index = \(index), root = \(root)")
                root.tabBarItem = UITabBarItem(title: tabBarTitle[index],
                                               image: tabBarImage[index].withTintColor(.black).withRenderingMode(.alwaysOriginal),
                                               selectedImage: tabBarImageS[index].withTintColor(.black).withRenderingMode(.alwaysOriginal))
                root.tabBarItem.imageInsets = UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0)
                root.tabBarItem.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 0)
            }
            
            UITabBarItem.setupBarItem()
            
            self.rootViewController.setViewControllers(roots, animated: true)
        }
        
        /// notificationFlow 가 준비 된 후에 딥링크 ㄱㄱ
//        Flows.use(notificationFlow, when: .ready) { _ in
//            AppDelegate.shared.readyNotificationFlow = true
//            if let scheme = urlScheme {
//                let nofiticationData = NotificationService.shared.parseLinkObject(directUrlScheme: scheme)
//                NotificationService.shared.mapper(model: nofiticationData)
//            } else if let deepLink = AppDelegate.shared.readyDeepLink {
//                ARLinkService.shared.link(linkType: .deep, link: deepLink)
//                AppDelegate.shared.readyDeepLink = nil
//            }
//        }
        
        return .multiple(flowContributors: [
            .contribute(withNextPresentable: homeFlow, withNextStepper: ExchangeStepper.shared),
            .contribute(withNextPresentable: boardFlow, withNextStepper: BoardStepper.shared),
            .contribute(withNextPresentable: newsFlow, withNextStepper: NewsStepper.shared)
//            .contribute(withNextPresentable: notificationFlow, withNextStepper: NotificationStepper.shared)
        ])
    }
}
