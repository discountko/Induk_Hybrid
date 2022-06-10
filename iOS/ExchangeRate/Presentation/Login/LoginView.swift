//
//  LoginView.swift
//  ExchangeRate
//
//  Created by pineone on 2022/04/18.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

class LoginView: UIBasePreviewType {
    
    // MARK: - Model type implemente
    typealias Model = Void
    
    let actionRelay = PublishRelay<LoginActionType>()
    
    // MARK: - init
    override init(naviType: BaseNavigationShowType = .none) {
        super.init(naviType: naviType)
        setupLayout()
        bindData()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        emailSignUp.addBorder([.bottom], color: .darkGray, width: 1)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // TODO: - Deinit 개발 완료 한 뒤 메모리가 정상적으로 해제 되면 삭제!
    deinit {
        Log.d("로그 : \(self)!!")
    }
    
    // MARK: - View
    lazy var loginLabel = UILabel().then {
        $0.text = "로그인"
        $0.font = .notoSans(size: 22, weight: .bold)
    }
    
    lazy var email2 = TextField().then {
        $0.font = .notoSans(.regular, size: 16)
        $0.maximumTextLength = 15
        $0.keyboardType = .emailAddress
        $0.backgroundColor = .gray
    }
    
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
    
    lazy var container = UIView()
    
    lazy var emailSignUp = underLineButton("이메일로 가입")
    
    lazy var loginButton = UIButton().then {
        $0.setTitle("로그인", for: .normal)
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
        
        addSubviews([loginLabel, emailTextField, passwordTextField, container, emailSignUp, loginButton])
        
        loginLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(50)
            $0.bottom.equalTo(emailTextField.snp.top).offset(-50)
        }
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
        emailSignUp.snp.makeConstraints {
            $0.top.equalTo(passwordTextField.snp.bottom).offset(25)
            $0.centerX.equalToSuperview()
        }
        
        loginButton.snp.makeConstraints {
            $0.top.equalTo(passwordTextField.snp.bottom).offset(100)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(180)
            $0.height.equalTo(50)
        }
    }
    
    // MARK: - SetupDI
    /// User Input
    @discardableResult
    func setupDI(relay: PublishRelay<LoginActionType>) -> Self {
        actionRelay.bind(to: relay).disposed(by: rx.disposeBag)
        return self
    }
    
    func setupDI(observable: Observable<[Model]>) {
        // model Dependency Injection
    }
    
    func bindData() {
        loginButton.rx.tap
            .map { [weak self] in
                guard let `self` = self else { return .goHome(nil, nil) }
                
                let email = self.emailTextField.getText
                let password = self.passwordTextField.getText
                
                //return .goHome("test12@naver.com", "123456") // 주석해제후 바로 로그인 버튼 누르면 됨
                return .goHome(email, password)
            }
            .bind(to: actionRelay)
            .disposed(by: rx.disposeBag)
        
        emailSignUp.rx.tap
            .map { .emailSignUp }
            .bind(to: actionRelay)
            .disposed(by: rx.disposeBag)
    }
    
    func underLineButton(_ title: String) -> UIButton {
        let button = UIButton().then {
            $0.titleLabel?.font = .notoSans(size: 13)
            $0.setTitleColor(.darkGray, for: .normal)
            $0.setTitleColor(.black, for: .highlighted)
            $0.setTitle(title, for: .normal)
        }
        return button
    }
}


// MARK: - PreView
#if canImport(SwiftUI) && DEBUG
import SwiftUI

@available(iOS 13.0, *)
struct Login_Previews: PreviewProvider {
    static var previews: some View {
        //        Group {
        //            ForEach(UIView.previceSupportDevices, id: \.self) { deviceName in
        //                DebugPreviewView {
        //                    return LoginView()
        //                }.previewDevice(PreviewDevice(rawValue: deviceName))
        //                    .previewDisplayName(deviceName)
        //                    .previewLayout(.sizeThatFits)
        //            }
        //        }        
        Group {
            DebugPreviewView {
                let view = LoginView()
                //                .then {
                //                    $0.setupDI(observable: Observable.just([]))
                //                }
                return view
            }
        }
    }
}
#endif
