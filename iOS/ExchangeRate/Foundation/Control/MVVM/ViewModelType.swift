//
//  ViewModelType.swift
//  Base
//
//  Created by pineone on 2021/08/04.
//

import Foundation

protocol ViewModelType: ViewModel {
    // ViewModel
    associatedtype ViewModel: ViewModelType

    // Input
    associatedtype Input

    // Output
    associatedtype Output

    func transform(req: ViewModel.Input) -> ViewModel.Output
}
