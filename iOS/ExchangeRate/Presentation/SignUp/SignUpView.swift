//
//  SignUpView.swift
//  ExchangeRate
//
//  Created by pineone on 2022/05/02.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

class SignUpView: UIBasePreviewType {
    
    // MARK: - Model type implemente
    typealias Model = Void
    
    let actionRelay = PublishRelay<SignUpActionType>()
    
    // MARK: - init
    override init(naviType: BaseNavigationShowType = .backCenterTitle) {
        super.init(naviType: naviType)
        naviBar.title = "회원가입"
        setupLayout()
        bindData()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // TODO: - Deinit 개발 완료 한 뒤 메모리가 정상적으로 해제 되면 삭제!
    deinit {
        Log.d("로그 : \(self)!!")
    }
    
    // MARK: - View
    lazy var textFieldModel: ((Bool) -> TextFieldConfigModel) = { bool -> TextFieldConfigModel in
        TextFieldConfigModel(maxLength: 60,
                             maxLine: 0,
                             textFieldFont: .notoSans(size: 16, weight: .medium),
                             textFieldAlignment: .left,
                             placeHolder: bool ? "아이디 (이메일)" : "비밀번호",
                             placeHolderFont: .notoSans(size: 16, weight: .medium),
                             placeHolderColor: R.Color.Main.textOpac40,
                             placeHolderLeftPadding: 12,
                             placeHolderRightPadding: 12,
                             needTextFieldAddButton: false,
                             needTextFieldClearButton: bool,
                             needPreBackGroundColor: true,
                             needSecureText: !bool,
                             endEditingWithView: nil)
    }
    /// 제목 텍스트 필드
    lazy var emailTextField = CustomTextField(model: textFieldModel(true)).then {
        $0.getTextField().autocorrectionType = .no
    }
    
    lazy var passwordTextField = CustomTextField(model: textFieldModel(false)).then {
        $0.getTextField().autocorrectionType = .no
    }
    
    lazy var signUpButton = UIButton().then {
        $0.setTitle("회원가입", for: .normal)
        $0.setBackgroundColor(R.Color.purple, for: .normal)
        $0.titleLabel?.font = .notoSans(size: 22, weight: .bold)
        $0.cornerRadius = 10
        $0.borderWidth = 1
        $0.borderColor = UIColor(226, 226, 230, 0.7)
    }
    
    // MARK: - Outlets
    
    // MARK: - Methods
    func setupLayout() {
        backgroundColor = .white
        
        addSubviews([emailTextField, passwordTextField, signUpButton])
        emailTextField.snp.makeConstraints {
            $0.centerY.equalToSuperview().offset(-130)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(300)
            $0.height.equalTo(45)
        }
        passwordTextField.snp.makeConstraints {
            $0.top.equalTo(emailTextField.snp.bottom).offset(15)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(300)
            $0.height.equalTo(45)
        }
        signUpButton.snp.makeConstraints {
            $0.top.equalTo(passwordTextField.snp.bottom).offset(100)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(180)
            $0.height.equalTo(50)
        }
    }
    
    // MARK: - SetupDI
    /// User Input
    @discardableResult
    func setupDI(relay: PublishRelay<SignUpActionType>) -> Self {
        actionRelay.bind(to: relay).disposed(by: rx.disposeBag)
        return self
    }
    
    func setupDI(observable: Observable<[Model]>) {
        // model Dependency Injection
    }
    
    func bindData() {
        signUpButton.rx.tap
            .map {
                let email = self.emailTextField.getText
                let password = self.passwordTextField.getText
                return .signUp(email, password) }
            .bind(to: actionRelay)
            .disposed(by: rx.disposeBag)
    }
}


// MARK: - PreView
#if canImport(SwiftUI) && DEBUG
import SwiftUI

@available(iOS 13.0, *)
struct SignUp_Previews: PreviewProvider {
    static var previews: some View {
        //        Group {
        //            ForEach(UIView.previceSupportDevices, id: \.self) { deviceName in
        //                DebugPreviewView {
        //                    return SignUpView()
        //                }.previewDevice(PreviewDevice(rawValue: deviceName))
        //                    .previewDisplayName(deviceName)
        //                    .previewLayout(.sizeThatFits)
        //            }
        //        }        
        Group {
            DebugPreviewView {
                let view = SignUpView()
                //                .then {
                //                    $0.setupDI(observable: Observable.just([]))
                //                }
                return view
            }
        }
    }
}
#endif
