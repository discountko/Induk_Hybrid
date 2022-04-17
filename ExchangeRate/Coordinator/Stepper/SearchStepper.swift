//
//  SearchStepper.swift
//  Base
//
//  Created by pineone on 2021/09/23.
//

import RxCocoa
import RxFlow
import UIKit

class SearchStepper: Stepper {
    static let shared = SearchStepper()

    let steps = PublishRelay<Step>()

    var initialStep: Step = MainSteps.search

    private init() {}

    func readyToEmitSteps() {
    }
}
