//
//  AppStepper.swift
//  Base
//
//  Created by pineone on 2021/08/04.
//

import RxCocoa
import RxFlow
import UIKit

class AppStepper: Stepper {
    
    static let shared = AppStepper()
    
    let steps = PublishRelay<Step>()

    var initialStep: Step {
        return MainSteps.initialization
    }

    func readyToEmitSteps() {
    }
    
    func exitApp() {
        steps.accept(MainSteps.exitApp)
    }

    func permissionComplete() {
        steps.accept(MainSteps.permissionCompleted)
    }
}
