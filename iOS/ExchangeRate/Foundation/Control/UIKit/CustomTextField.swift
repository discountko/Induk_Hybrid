//
//  CustomTextField.swift
//  ExchangeRate
//
//  Created by pineone on 2022/04/18.
//

import UIKit
import RxSwift
import RxCocoa
import RxOptional

struct TextFieldConfigModel {
    let maxLength: Int?
    let maxLine: Int
    let textFieldFont: UIFont?
    let textFieldAlignment: NSTextAlignment?
    let placeHolder: String
    let placeHolderFont: UIFont?
    let placeHolderColor: UIColor?
    let placeHolderLeftPadding: CGFloat?
    let placeHolderRightPadding: CGFloat?
    let needTextFieldAddButton: Bool?
    let needTextFieldClearButton: Bool?
    let needPreBackGroundColor: Bool?
    let needSecureText: Bool?
    weak var endEditingWithView: UIView?
}

class CustomTextField: CustomTextBase {
    
    /// TextView에 포커스가 있는지 여부
    private var hasFocus: Bool = false

    /// disable 처리
    var isEnabled: Bool = true {
        didSet {
            self.isUserInteractionEnabled = isEnabled
            self.textField.isUserInteractionEnabled = isEnabled
            self.clearButton.isUserInteractionEnabled = isEnabled
            updateBackgroundColor()
            updateTextColor()
        }
    }

    /// normal /dim Text Color
    var normalTextColor: UIColor = .black {
        didSet { updateTextColor() }
    }
    var disabledTextColor: UIColor = UIColor(204, 204, 204) {
        didSet { updateTextColor() }
    }
    
    /// 최대 글자수를 지정할수있습니다.
    private var maxLength: Int?
    
    /// 최대 라인수를 지정할수있습니다. ( 0 : 제한 없슴 )
    private var maxLine: Int = 0
    
    /// 텍스트필드의 폰트를 지정할수있습니다.
    private var textFieldFont: UIFont?
    /// 텍스트필드의 정렬 위치를 지정할수있습니다.
    private var textFieldAlignment: NSTextAlignment?
    /// 플레이스홀더 내용을 지정할수있습니다.
    private var placeHolder: String = ""
    /// 플레이스홀더 폰트를 지정할수있습니다.
    private var placeHolderFont: UIFont?
    /// 플레이스홀더 폰트컬러를 지정할수있습니다.
    private var placeHolderColor: UIColor?
    /// 플레이스홀더의 왼쪽 여백을 지정할수있습니다.
    private var placeHolderLeftPadding: CGFloat?
    /// 플레이스홀더 오른쪽 여백을 지정할수있습니다.
    private var placeHolderRightPadding: CGFloat?
    /// 텍스트필드의 텍스트를 모두 지울수있는 클리어 버튼을 추가할지 지정할수있습니다.
    private var needTextFieldClearButton: Bool?
    /// 입력상태가 아닐때 텍스트필드의 백그라운드컬러를 사용할지 지정할수있습니다.
    private var needPreBackGroundColor: Bool = false
    /// 텍스트의 값을 숨길지 여부 입니다.
    private var needSecureText: Bool?
    ///  프로퍼티로 전달된 뷰에 탭(포커스아웃)을 통해 텍스트뷰 편집을 종료할수있습니다.
    private weak var endEditingWithView: UIView?
    
    /// custom clear버튼 클릭 callback
    private var customClearButtonAction: (() -> Void)? = nil
    
    /// custom textfield return text
    private var customTextFieldReturnTextAction: ((String?) -> Void)? = nil
    
    private lazy var baseView = UIView().then {
        $0.backgroundColor = needPreBackGroundColor ? #colorLiteral(red: 0.9568627451, green: 0.9568627451, blue: 0.9568627451, alpha: 1) : #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        $0.layer.borderColor = #colorLiteral(red: 0.9254901961, green: 0.9254901961, blue: 0.9254901961, alpha: 1)
        $0.layer.cornerRadius = 10
        $0.layer.borderWidth = 1
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private lazy var textField = UITextField().then {
        $0.delegate = self
        $0.textColor = normalTextColor
        $0.backgroundColor = .clear
        $0.font = textFieldFont
        $0.textAlignment = textFieldAlignment ?? .left
        $0.isSecureTextEntry = needSecureText ?? false
        let placeHolderAttr = NSAttributedString(string: placeHolder, attributes: [.foregroundColor: placeHolderColor ?? UIColor.lightGray,
                                                                                   .font: placeHolderFont ?? .notoSans(size: 16, weight: .regular)])
        $0.attributedPlaceholder = placeHolderAttr
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private lazy var clearButton = UIButton().then {
        $0.setImage(#imageLiteral(resourceName: "Union"), for: .normal)
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    init(model: TextFieldConfigModel) {
        super.init(frame: .zero)
        setupValue(model: model)
        setupLayout()
        bindRx()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// initialize 모델에 따라 텍스트필드 구성에 필요한 프로퍼티 값을 설정합니다.
    private func setupValue(model: TextFieldConfigModel) {
        maxLength = model.maxLength
        maxLine = model.maxLine
        textFieldFont = model.textFieldFont
        textFieldAlignment = model.textFieldAlignment
        placeHolder = model.placeHolder
        placeHolderFont = model.placeHolderFont
        placeHolderColor = model.placeHolderColor
        placeHolderLeftPadding = model.placeHolderLeftPadding
        placeHolderRightPadding = model.placeHolderRightPadding
        needTextFieldClearButton = model.needTextFieldClearButton
        needPreBackGroundColor = model.needPreBackGroundColor ?? false
        needSecureText = model.needSecureText
        endEditingWithView = model.endEditingWithView
    }
    
    private func setupLayout() {
        addSubview(baseView)
        baseView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        baseView.addSubview(textField)
        textField.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().offset(placeHolderLeftPadding ?? 12)
            $0.bottom.equalToSuperview()
            $0.trailing.equalToSuperview().offset(-(placeHolderRightPadding ?? 12))
        }
        if needTextFieldClearButton ?? false {
            baseView.addSubview(clearButton)
            clearButton.snp.makeConstraints {
                $0.top.equalToSuperview().offset(8)
                $0.trailing.equalToSuperview().offset(-8)
                $0.bottom.equalToSuperview().offset(-8)
                $0.size.equalTo(24)
            }
            textField.snp.remakeConstraints {
                $0.top.equalToSuperview()
                $0.leading.equalToSuperview().offset(placeHolderLeftPadding ?? 12)
                $0.bottom.equalToSuperview()
                $0.trailing.equalTo(clearButton.snp.leading).offset(-8)
            }
        }
    }
    private func bindRx() {
        /// 사용자가 입력한 경우, 코드로 값을 셋팅한 경우 모두 textChanged() 호출되도록 처리
        textField.rx.text.subscribe(onNext: { [weak self] data in
            self?.textChanged(data.value.unwrap())
        }).disposed(by: rx.disposeBag)
        textField.rx.observe(String.self, "text").subscribe(onNext: { [weak self] data in
            self?.textChanged(data.value.unwrap())
        }).disposed(by: rx.disposeBag)

        /// edit외 영역을 클릭시, hide keyboard 처리
        endEditingWithView?.tapGesture().subscribe(onNext: { [weak self] _ in
            self?.endEditingWithView?.endEditing(true)
        }).disposed(by: rx.disposeBag)
        
        if needTextFieldClearButton ?? false {
            clearButton.rx.tap.throttle(.milliseconds(500), latest: false, scheduler: MainScheduler.instance)
                .on { [weak self] in
                    if let customClearButtonAction = self?.customClearButtonAction {
                        customClearButtonAction()
                    } else {
                        self?.textField.text = nil
                    }
                }.disposed(by: rx.disposeBag)
        }
        
        Observable.combineLatest(beforeText.asObservable(), afterText.asObservable())
            .observeOn(MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] before, after in
                guard let `self` = self else { return }
                self.checkMaxLength(before: before, after: after, maxLength: self.maxLength, maxLine: self.maxLine)
            }).disposed(by: rx.disposeBag)
    }

}

extension CustomTextField: UITextFieldDelegate {
    
    func textChanged(_ text: String) {
        afterText.accept(text)
        if needTextFieldClearButton ?? false {
            clearButton.isHidden = (text.count == 0)
        }
        customTextChangedAction?(text)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        
        if hasForbiddenCharacter(string) {
            return false
        } else if range.location >= text.utf16.count && range.length >= 1 {
            // 입력 가능한 글자 초과했을 때 키보드를 세 손가락으로 연타했을 경우 밑에 text.remove 인덱싱 에러나는 것 방지
            return false
        } else if string.isEmpty && range.length > 0 {
            // 인덱싱 에러 발생하지 않을 경우, 텍스트 지우기 했을 때
            return true
        } else {
            beforeText.accept(text)
            textRange.accept(textField.selectedTextRange)
            customTextOveredMaxLengthAction?(false)
            return true
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        hasFocus = true
        updateBackgroundColor()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        hasFocus = false
        updateBackgroundColor()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        customTextFieldReturnTextAction?(textField.text)
        endEditing(true)
        return true
    }
}

extension CustomTextField {
    
    func updateBackgroundColor() {
        if isEnabled {
            if hasFocus {
                //baseView.backgroundColor = (needPreBackGroundColor) ? .white : .white
                //[자체수정] 알림 UI 수정 및 검색 입력창 UI 수정
                //검색 입력창 배경 컬러 흰색->회색 수정
                baseView.backgroundColor = (needPreBackGroundColor) ? UIColor(244, 244, 244) : .white
                baseView.layer.borderColor = UIColor(85, 55, 214).cgColor
            } else {
                baseView.backgroundColor = (needPreBackGroundColor) ? UIColor(244, 244, 244) : .white
                baseView.layer.borderColor = UIColor(236, 236, 236).cgColor
            }
        } else {
            baseView.backgroundColor = UIColor(209, 209, 209) ~ 30%
            baseView.layer.borderColor = baseView.backgroundColor?.cgColor
        }
    }
    
    func updateTextColor() {
        if isEnabled {
            textField.textColor = normalTextColor
        } else {
            textField.textColor = disabledTextColor
        }
    }
    
}

extension CustomTextField {
    
    var getText: String? {
        return textField.text
    }
    
    func getTextField() -> UITextField {
        return textField
    }
    
    func getClearButton() -> UIButton {
        return clearButton
    }

    override func becomeFirstResponder() -> Bool {
        return textField.becomeFirstResponder()
    }

    override func resignFirstResponder() -> Bool {
        return textField.resignFirstResponder()
    }
    
    func setCustomClearButtonAction(handler: @escaping () -> Void) {
        customClearButtonAction = handler
    }
    
    func setCustomTextFieldReturnTextAction(handler: @escaping (String?) -> Void) {
        customTextFieldReturnTextAction = handler
    }

}

