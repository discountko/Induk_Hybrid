//
//  BoardViewController.swift
//  Basic
//
//  Created by pineone on 2021/09/23.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Reusable
import SnapKit
import Then

class BoardViewController: UIBaseViewController, ViewModelProtocol {
    typealias ViewModel = BoardViewModel
    
    // MARK: - ViewModelProtocol
    var viewModel: ViewModel!
    
    // MARK: - Properties
    private let actionRelay = PublishRelay<BoardActionType>()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupLayout()
        bindingViewModel()
    }
    
    // MARK: - Binding
    func bindingViewModel() {
        _ = viewModel.transform(req: ViewModel.Input(naviBarTrigger: subView.naviBar.navigationAction,
                                                     actionTrigger: actionRelay))
        
        subView
            .setupDI(relay: actionRelay)
    }
    
    // MARK: - View
    let subView = BoardView()
    
    func setupLayout() {
        view.addSubview(subView)
        subView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    // MARK: - Methods
    
}
