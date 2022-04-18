//
//  MoreSeeFlow.swift
//  Base
//
//  Created by pineone on 2021/09/16.
//

import RxCocoa
import RxFlow
import RxSwift
import UIKit

class MoreSeeFlow: BaseFlow {
    override func navigate(to step: Step) -> FlowContributors {
        let superContributors = super.navigate(to: step)
        if !superContributors.isNone {
            return superContributors
        }
        
        guard let step = step as? MainSteps else { return .none }
        switch step {
        case .moreSee:
            return navigateMoreScreen()
        default:
            return .none
        }
    }
}

extension MoreSeeFlow {
    func navigateMoreScreen() -> FlowContributors {
        return FlowSugar(viewModel: MoreSeeViewModel())
            .presentable(MoreSeeViewController.self)
            .oneStepPushBy(navigationController)
    }
}
