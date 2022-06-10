//
//  NewsStepper.swift
//  Base
//
//  Created by pineone on 2021/09/16.
//

import RxCocoa
import RxFlow
import RxSwift
import UIKit

class NewsStepper: Stepper {
    static let shared = NewsStepper()

    var steps = PublishRelay<Step>()
    
    var initialStep: Step = MainSteps.news

    private init() {}

    func readyToEmitSteps() {
    }
}
