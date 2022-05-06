//
//  SignUpViewController.swift
//  ExchangeRate
//
//  Created by pineone on 2022/05/02.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Reusable
import SnapKit
import Then

class SignUpViewController: UIBaseViewController, ViewModelProtocol {
    typealias ViewModel = SignUpViewModel
    
    // MARK: - ViewModelProtocol
    var viewModel: ViewModel!
    
    // MARK: - Properties
    private let actionRelay = PublishRelay<SignUpActionType>()
    var tapGesture: UITapGestureRecognizer?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupLayout()
        bindingViewModel()
    }
    
    // TODO: - Deinit 개발 완료 한 뒤 메모리가 정상적으로 해제 되면 삭제!
    deinit {
        Log.d("로그 : \(self)!!")
    }
    
    // MARK: - Binding
    func bindingViewModel() {
        _ = viewModel.transform(req: ViewModel.Input(naviBarTrigger: subView.naviBar.navigationAction,
                                                     actionTrigger: actionRelay))
        
        subView
            .setupDI(relay: actionRelay)
        
        /// 키보드 나오면, 바깥부분 클릭시 키보드 내리는 옵저버 추가
        NotificationCenter.default.rx.notification(UIResponder.keyboardWillShowNotification)
            .subscribe(onNext: { [weak self] noti in
                guard let `self` = self else { return }
                self.tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
                self.tapGesture?.cancelsTouchesInView = false
                self.subView.addGestureRecognizer(self.tapGesture!)
            }).disposed(by: rx.disposeBag)
        
        /// 키보드 들어가면, 옵저버 삭제
        NotificationCenter.default.rx.notification(UIResponder.keyboardWillHideNotification)
            .subscribe(onNext: { [weak self] noti in
                guard let `self` = self else { return }
                if self.tapGesture != nil {
                    self.subView.removeGestureRecognizer(self.tapGesture!)
                }
            }).disposed(by: rx.disposeBag)
    }
    
    // MARK: - View
    let subView = SignUpView()
    
    func setupLayout() {
        view.addSubview(subView)
        subView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    // MARK: - Methods
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
}
