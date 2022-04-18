//
//  ExchangeStepper.swift
//  Base
//
//  Created by pineone on 2021/09/16.
//

import RxCocoa
import RxFlow
import UIKit

class ExchangeStepper: Stepper {
    static let shared = ExchangeStepper()

    let steps = PublishRelay<Step>()

    var initialStep: Step {
        return MainSteps.home
    }
    
    private init() {}

    func readyToEmitSteps() {
    }
}
