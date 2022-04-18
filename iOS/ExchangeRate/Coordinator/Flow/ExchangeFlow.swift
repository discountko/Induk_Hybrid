//
//  ExchangeFlow.swift
//  Base
//
//  Created by pineone on 2021/09/14.
//

import RxFlow
import UIKit

class ExchangeFlow: BaseFlow {
    
    override func navigate(to step: Step) -> FlowContributors {
        let superContributors = super.navigate(to: step)
        if !superContributors.isNone {
            return superContributors
        }

        guard let step = step as? MainSteps else { return .none }
        switch step {
        case .home:
            return self.navigateToExcahngeScreen()

        case .popViewController:
            _ = self.navigationController.popViewController(animated: true)
            return .none

        case .popModal:
            self.navigationController.dismiss(animated: true, completion: nil)
            return .none
            
        case .popToRootVC:
            BaseTabBarController.shared.viewControllers?.forEach {
                if let navigation = $0 as? BaseNavigationController {
                    _ = navigation.popToRootViewController(animated: false)
                }
            }
            return .none
            
        default:
            return .none
        }
    }
}

extension ExchangeFlow {
    private func navigateToExcahngeScreen() -> FlowContributors {
        return FlowSugar(viewModel: ExchangeViewModel())
            .presentable(ExchangeViewController.self)
            .oneStepPushBy(navigationController)
    }

}

extension ExchangeFlow {
//    private func navigateToRequest(type: HomePushRequsetType) -> FlowContributors {
//        if let home = navigationController.children.first as? homeViewController {
//            home.flowRequest(type)
//        }
//        return .none
//    }
}
