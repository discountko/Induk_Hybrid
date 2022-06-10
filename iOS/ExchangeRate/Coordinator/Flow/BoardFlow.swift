//
//  BoardFlow.swift
//  Base
//
//  Created by pineone on 2021/09/23.
//

import RxCocoa
import RxFlow
import RxSwift
import UIKit

class BoardFlow: BaseFlow {
    override func navigate(to step: Step) -> FlowContributors {
        let superContributors = super.navigate(to: step)
        if !superContributors.isNone {
            return superContributors
        }
        
        guard let step = step as? MainSteps else { return .none }
        switch step {
        case .board:
            return navigateBoardScreen()
        case .popModal:
            self.navigationController.dismiss(animated: true, completion: nil)
            return .none
        default:
            return .none
        }
    }
}

extension BoardFlow {
    func navigateBoardScreen() -> FlowContributors {
        return FlowSugar(viewModel: BoardViewModel())
            .presentable(BoardViewController.self)
            .oneStepPushBy(navigationController)
    }
}
