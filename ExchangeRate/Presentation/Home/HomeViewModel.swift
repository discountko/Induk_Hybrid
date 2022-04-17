//
//  HomeViewModel.swift
//  Basic
//
//  Created by pineone on 2021/09/16.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import RxFlow

enum HomeActionType {
    case test
}

class HomeViewModel: ViewModelType, Stepper {
    // MARK: - Stepper
    var steps = PublishRelay<Step>()
    
    let disposeBag = DisposeBag()
    
    // MARK: - ViewModelType Protocol
    typealias ViewModel = HomeViewModel
    
    struct Input {
        let actionTrigger: PublishRelay<HomeActionType>
    }
    
    struct Output {
    }
    
    func transform(req: ViewModel.Input) -> ViewModel.Output {
        req.actionTrigger.bind(onNext: actionForButton(_:)).disposed(by: disposeBag)
        
        return Output()
    }
    
    func actionForButton(_ type: HomeActionType) {
        switch type {
        case .test:
            movieListLoad(limit: 10, 1, 5)
        }
    }
    
    
    func movieListLoad(limit: Int, _ page: Int, _ minimumRating: Int) {
        _ = NetworkService.movieList(limit: limit, page: page, minimumRating: minimumRating)
            .asObservable()
            .subscribe(onNext: { data in
                
                let tt = (data.pageNumber, data.limit)
                
                print("jhKim : \(tt)")
                
                
                
            }).disposed(by: disposeBag)
        
    }
}
