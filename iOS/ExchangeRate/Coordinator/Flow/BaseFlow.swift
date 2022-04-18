//
//  BaseFlow.swift
//  Base
//
//  Created by pineone on 2021/09/14.
//

import RxFlow
import UIKit

class BaseFlow: Flow {
    var root: Presentable {
        return navigationController
    }

    var navigationController = BaseNavigationController().then {
        $0.setNavigationBarHidden(true, animated: false)
    }

    @discardableResult
    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? MainSteps else { return .none }

        switch step {
        /// 하단 탭바들이 유지되야해서 push/pop형식으로 바꿈
        case .popToRootVC:
            navigationController.popToRootViewController(animated: true)
            return .none
        case .dismissModal:
            navigationController.dismiss(animated: true)
            return .none
        case .popVC:
            navigationController.popViewController(animated: true)
            return .none
        default: return .none
        }
    }
}

extension BaseFlow {
    /// 공유하기 공통 로직
    private func shareAsset(_ list: [Any], _ handler: UIActivityViewController.CompletionWithItemsHandler? = nil) -> FlowContributors {
        let activityViewController = UIActivityViewController(activityItems: list, applicationActivities: nil)

        activityViewController.completionWithItemsHandler = handler

        activityViewController.excludedActivityTypes = [UIActivity.ActivityType.saveToCameraRoll]

        activityViewController.popoverPresentationController?.sourceView = UIApplication.shared.topViewController?.view

        UIApplication.shared.topViewController?.present(activityViewController, animated: true, completion: {
            //로딩창
        })

        return .none
    }
}



extension FlowContributors {
    var isNone: Bool {
        switch self {
        case .none:
            return true
        default:
            return false
        }
    }
}
