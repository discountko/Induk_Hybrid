//
//  MainFlow.swift
//  ExchangeRate
//
//  Created by pineone on 2022/05/04.
//

import RxFlow
import UIKit

class MainFlow: Flow {
    var root: Presentable { return rootViewController }
    
    private lazy var rootViewController = BaseTabBarController.shared
    
    var tabBarTitle: [String] { return ["환율전환", "게시판", "뉴스"] }
    
    var sfSymbols = ["person.crop.circle", "person.crop.circle.fill",
                     "house.circle", "house.circle.fill",
                     "newspaper.circle", "newspaper.circle.fill"]
    
    var tabBarImage: [UIImage] {
        return [UIImage(systemName: sfSymbols[0])!, UIImage(systemName: sfSymbols[2])!, UIImage(systemName: sfSymbols[4])!]
        
    }
    var tabBarImageS: [UIImage] {
        return [UIImage(systemName: sfSymbols[1])!, UIImage(systemName: sfSymbols[3])!, UIImage(systemName: sfSymbols[5])!]
    }
    
    
    // MARK: Method
    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? MainSteps  else { return .none }
        
        switch step {
        case .moveToMain:
            return moveToHome()
        case .moveTab(let index):
            rootViewController.selectTabBarWith(index: index)
        default:
            break
        }
        return .none
    }
    
    private func moveToHome() -> FlowContributors {
        // 탭바 초기 설정
        let homeFlow = ExchangeFlow()
        let boardFlow = BoardFlow()
        let newsFlow = NewsFlow()
        
        let flows: [Flow] = [homeFlow, boardFlow, newsFlow]
        Flows.use(flows, when: .ready) { [unowned self] (roots: [BaseNavigationController]) in
            for(index, root) in roots.enumerated() {
                Log.d("index = \(index), root = \(root)")
                root.tabBarItem = UITabBarItem(title: tabBarTitle[index],
                                               image: tabBarImage[index].withTintColor(.black).withRenderingMode(.alwaysOriginal),
                                               selectedImage: tabBarImageS[index].withTintColor(.black).withRenderingMode(.alwaysOriginal))
                root.tabBarItem.imageInsets = UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0)
                root.tabBarItem.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 0)
            }
            
            UITabBarItem.setupBarItem()
            
            rootViewController.tabBar.isHidden = false
            rootViewController.setViewControllers(roots, animated: false)
        }
        return .multiple(flowContributors: [
            .contribute(withNextPresentable: homeFlow, withNextStepper: ExchangeStepper.shared),
            .contribute(withNextPresentable: boardFlow, withNextStepper: BoardStepper.shared),
            .contribute(withNextPresentable: newsFlow, withNextStepper: NewsStepper.shared)
        ])
    }
}
