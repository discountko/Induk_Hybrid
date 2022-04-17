//
//  HomeStepper.swift
//  Base
//
//  Created by pineone on 2021/09/16.
//

import RxCocoa
import RxFlow
import UIKit

class HomeStepper: Stepper {
    static let shared = HomeStepper()

    let steps = PublishRelay<Step>()

    var initialStep: Step {
        return MainSteps.home
    }
    
    private init() {}

    func readyToEmitSteps() {
    }
}
