//
//  BoardStepper.swift
//  Base
//
//  Created by pineone on 2021/09/23.
//

import RxCocoa
import RxFlow
import UIKit

class BoardStepper: Stepper {
    static let shared = BoardStepper()

    let steps = PublishRelay<Step>()

    var initialStep: Step = MainSteps.board

    private init() {}

    func readyToEmitSteps() {
    }
}
