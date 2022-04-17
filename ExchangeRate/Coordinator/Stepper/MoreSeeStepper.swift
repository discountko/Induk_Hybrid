//
//  MoreSeeStepper.swift
//  Base
//
//  Created by pineone on 2021/09/16.
//

import RxCocoa
import RxFlow
import RxSwift
import UIKit

class MoreSeeStepper: Stepper {
    static let shared = MoreSeeStepper()

    var steps = PublishRelay<Step>()
    
    var initialStep: Step = MainSteps.moreSee

    private init() {}

    func readyToEmitSteps() {
    }
}
