//
//  HomeViewController.swift
//  Basic
//
//  Created by pineone on 2021/09/16.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Reusable
import SnapKit
import Then

class HomeViewController: UIBaseViewController, ViewModelProtocol {
    typealias ViewModel = HomeViewModel
    
    // MARK: - ViewModelProtocol
    var viewModel: ViewModel!
    
    // MARK: - Properties
    private let actionRelay = PublishRelay<HomeActionType>()
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupLayout()
        bindingViewModel()
    }
    
    // MARK: - Binding
    func bindingViewModel() {
        _ = viewModel.transform(req: ViewModel.Input(actionTrigger: actionRelay))
        
        subView.setupDI(relay: actionRelay)
    }
    
    // MARK: - View
    let subView = HomeView()
    
    func setupLayout() {
        view.addSubview(subView)
        
        subView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-BaseTabBarController.shared.tabBarHeight)
        }
    }
    
    // MARK: - Methods
    
}
