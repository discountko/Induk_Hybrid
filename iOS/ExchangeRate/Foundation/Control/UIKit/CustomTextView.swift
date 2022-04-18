//
//  CustomTextView.swift
//  ExchangeRate
//
//  Created by pineone on 2022/04/18.
//

import RxSwift
import RxCocoa
import RxOptional


struct TextViewConfigModel {
    let maxLength: Int
    let maxLine: Int
    let textViewFont: UIFont?
    let textViewAlignment: NSTextAlignment?
    let placeHolder: String
    let placeHolderFont: UIFont?
    let placeHolderColor: UIColor?
    let placeHolderAlignment: NSTextAlignment?
    let placeHolderTopPadding: CGFloat
    let placeHolderBottomPadding: CGFloat
    let placeHolderRightPadding: CGFloat
    let placeHolderLeftPadding: CGFloat
    let needPreBackGroundColor: Bool?
    weak var endEditingWithView: UIView?
}

class CustomTextView: CustomTextBase {
    
    /// TextView에 포커스가 있는지 여부
    private var hasFocus: Bool = false

    /// disable 처리
    var isEnabled: Bool = true {
        didSet {
            self.isUserInteractionEnabled = isEnabled
            self.textView.isUserInteractionEnabled = isEnabled
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
    private var maxLength: Int = 100
    
    /// 최대 라인수를 지정할수있습니다. ( 0 : 제한 없슴 )
    private var maxLine: Int = 0
    
    /// 텍스트뷰의 폰트를 지정할수있습니다.
    private var textViewFont: UIFont? = UIFont.systemFont(ofSize: 17)
    /// 텍스트뷰의 정렬 위치를 지정할수있습니다.
    private var textViewAlignment: NSTextAlignment? = .justified

    /// 플레이스홀더 내용을 지정할수있습니다.
    private var placeHolder: String = ""
    /// 플레이스홀더 폰트를 지정할수있습니다.
    private var placeHolderFont: UIFont? = UIFont.systemFont(ofSize: 17)
    /// 플레이스홀더 폰트컬러를 지정할수있습니다.
    private var placeHolderColor: UIColor? = UIColor(white: 0.8, alpha: 1.0)
    /// 플레이스홀더 정렬 위치를 지정할수있습니다.
    private var placeHolderTextAlignment: NSTextAlignment?
    ///  플레이스홀더 위 여백을 지정할수있습니다.
    private var placeHolderTopPadding: CGFloat = 0
    ///  플레이스홀더 아래 여백을 지정할수있습니다.
    private var placeHolderBottomPadding: CGFloat = 0
    ///  플레이스홀더 오른쪽 여백을 지정할수있습니다.
    private var placeHolderRightPadding: CGFloat = 0
    ///  플레이스홀더 왼쪽 여백을 지정할수있습니다.
    private var placeHolderLeftPadding: CGFloat = 0
    
    ///  입력전(비활성화)상태에서의 텍스트뷰 백그라운드컬러를 사용할지 지정할수있습니다.
    private var needPreBackGroundColor: Bool = false
    ///  프로퍼티로 전달된 뷰에 탭(포커스아웃)을 통해 텍스트뷰 편집을 종료할수있습니다.
    private weak var endEditingWithView: UIView?
    
    /// 프로필 소개글 등록의 placeHolder가 상단 센터로 정렬되어야 함. 정렬기능으로 상단센터를 제공하지 않으므로 영역을 한라인으로 줄여서 상단 센터로 처리하기 위해 추가함
    private var isOneLinePlaceHolder: Bool = false
    
    private lazy var baseView = UIView().then {
        $0.backgroundColor = needPreBackGroundColor ? #colorLiteral(red: 0.9568627451, green: 0.9568627451, blue: 0.9568627451, alpha: 1) : #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1) //RGB 255 255 255
        $0.layer.borderColor = #colorLiteral(red: 0.9254901961, green: 0.9254901961, blue: 0.9254901961, alpha: 1) //RGB 236 236 236
        $0.layer.cornerRadius = 10
        $0.layer.borderWidth = 1
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private lazy var textView = UITextView().then {
        $0.delegate = self
        $0.textColor = normalTextColor
        $0.font = textViewFont
        $0.textAlignment = textViewAlignment ?? .justified
        $0.backgroundColor = .clear
        $0.alwaysBounceVertical = true
        $0.smartInsertDeleteType = .no
        $0.showsHorizontalScrollIndicator = false
        $0.textContainerInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        $0.textContainer.lineFragmentPadding = 0
    }
    
    private lazy var placeHolderLabel = UILabel().then {
        $0.text = placeHolder
        $0.font = placeHolderFont
        $0.textColor = placeHolderColor
        $0.textAlignment = placeHolderTextAlignment ?? .center
        $0.numberOfLines = 1
        $0.lineBreakMode = .byWordWrapping
        $0.isUserInteractionEnabled = false
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private lazy var maxLengthLabel = UILabel().then {
        $0.text = "0/\(maxLength)"
        $0.font = .notoSans(size: 10, weight: .medium)
        $0.textColor = #colorLiteral(red: 0.631372549, green: 0.631372549, blue: 0.631372549, alpha: 1) //RGB 161 161 161
        $0.numberOfLines = 1
        $0.textAlignment = .right
        $0.isUserInteractionEnabled = false
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private lazy var leftBottomInfoLabel = UILabel().then {
        $0.text = ""
        $0.font = .notoSans(size: 10, weight: .medium)
        $0.textColor = #colorLiteral(red: 0.3411764706, green: 0.2156862745, blue: 0.8392156863, alpha: 1) //RGB 87 55 214
        $0.numberOfLines = 1
        $0.textAlignment = .left
        $0.isUserInteractionEnabled = false
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.isHidden = true
    }
    
    init(model: TextViewConfigModel, isOneLinePlaceHolder: Bool = false) {
        super.init(frame: .zero)
        self.isOneLinePlaceHolder = isOneLinePlaceHolder
        setupValue(model: model)
        setupLayout()
        bindRx()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// initialize 모델에 따라 텍스트뷰 구성에 필요한 프로퍼티 값을 설정합니다.
    private func setupValue(model: TextViewConfigModel) {
        maxLength = model.maxLength
        maxLine = model.maxLine
        textViewFont = model.textViewFont
        textViewAlignment = model.textViewAlignment
        placeHolder = model.placeHolder
        placeHolderFont = model.placeHolderFont
        placeHolderColor = model.placeHolderColor
        placeHolderTextAlignment = model.placeHolderAlignment
        placeHolderTopPadding = model.placeHolderTopPadding
        placeHolderBottomPadding = model.placeHolderBottomPadding
        placeHolderRightPadding = model.placeHolderRightPadding
        placeHolderLeftPadding = model.placeHolderLeftPadding
        needPreBackGroundColor = model.needPreBackGroundColor ?? false
        endEditingWithView = model.endEditingWithView
    }
    
    private func setupLayout() {
        addSubview(baseView)
        baseView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        baseView.addSubviews([leftBottomInfoLabel, maxLengthLabel, placeHolderLabel, textView])
        textView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(placeHolderLeftPadding)
            $0.trailing.equalToSuperview().offset(-placeHolderRightPadding)
            $0.top.equalToSuperview().offset(placeHolderTopPadding)
            ///$0.bottom.equalToSuperview().offset(-placeHolderBottomPadding)
        }
        placeHolderLabel.snp.makeConstraints {
            if isOneLinePlaceHolder, let placeHolderFontHeight = placeHolderFont?.lineHeight {
                $0.leading.trailing.top.equalTo(textView)
                $0.width.equalTo(placeHolderFontHeight)
            } else {
                $0.leading.trailing.top.bottom.equalTo(textView)
            }
        }
        maxLengthLabel.snp.makeConstraints {
            $0.top.equalTo(textView.snp.bottom).offset(14)
            $0.trailing.equalToSuperview().offset(-16)
            $0.bottom.equalToSuperview().offset(-16)
            //$0.height.equalTo(maxLengthLabel.font.pointSize)
        }
        leftBottomInfoLabel.snp.makeConstraints {
            //$0.top.equalTo(textView.snp.bottom).offset(14)
            $0.leading.equalToSuperview().offset(16)
            $0.bottom.equalToSuperview().offset(-16)
            //$0.height.equalTo(maxLengthLabel.font.pointSize)
        }
    }
    
    private func bindRx() {
        /// 사용자가 입력한 경우, 코드로 값을 셋팅한 경우 모두 textChanged() 호출되도록 처리
        textView.rx.text
            .subscribe(onNext: { [weak self] data in
                //let tt = data.va
                self?.textChanged(data.value.unwrap())
            }).disposed(by: rx.disposeBag)
        textView.rx.observe(String.self, "text")
            .subscribe(onNext: { [weak self] data in
                self?.textChanged(data.value.unwrap())
            }).disposed(by: rx.disposeBag)
        
        /// edit외 영역을 클릭시, hide keyboard 처리
        endEditingWithView?.tapGesture().subscribe(onNext: { [weak self] _ in
            self?.endEditingWithView?.endEditing(true)
        }).disposed(by: rx.disposeBag)

        /// textview 하단영역을 클릭했을때도, show keyboard 되도록...
        baseView.tapGesture().subscribe(onNext: { [weak self] _ in
            self?.becomeFirstResponder()
        }).disposed(by: rx.disposeBag)
        
        Observable.combineLatest(beforeText.asObservable(), afterText.asObservable())
            .observeOn(MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] before, after in
                guard let `self` = self else { return }
                self.checkMaxLength(before: before, after: after, maxLength: self.maxLength, maxLine: self.maxLine)
            }).disposed(by: rx.disposeBag)
    }
}

extension CustomTextView: UITextViewDelegate {
    func textChanged(_ text: String) {
        afterText.accept(text)
        customTextChangedAction?(text)
        placeHolderLabel.isHidden = text.count > 0
        maxLengthLabel.text = "\(text.utf16.count)/\(maxLength)"
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        hasFocus = true
        updateBackgroundColor()
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        hasFocus = false
        updateBackgroundColor()
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if hasForbiddenCharacter(text) {
            return false
        } else {
            beforeText.accept(textView.text.unwrap())
            textRange.accept(textView.selectedTextRange)
            customTextOveredMaxLengthAction?(false)
            return true
        }
    }
}

extension CustomTextView {
    
    func updateBackgroundColor() {
        if isEnabled {
            if hasFocus {
                baseView.backgroundColor = .white
                baseView.layer.borderColor = UIColor(87, 55, 214).cgColor
            } else {
                baseView.backgroundColor =
                    (needPreBackGroundColor && (textView.text == nil || textView.text.isEmpty)) ? UIColor(244, 244, 244) : .white
                baseView.layer.borderColor = UIColor(236, 236, 236).cgColor
            }
        } else {
            baseView.backgroundColor = UIColor(209, 209, 209) ~ 30%
            baseView.layer.borderColor = baseView.backgroundColor?.cgColor
        }
    }
    
    func updateTextColor() {
        if isEnabled {
            textView.textColor = normalTextColor
        } else {
            textView.textColor = disabledTextColor
        }
    }
    
    func setLeftBottomInfo(_ infoText:String) {
        leftBottomInfoLabel.text = infoText
        leftBottomInfoLabel.isHidden = false
    }
    
}

extension CustomTextView {

    func getTextView() -> UITextView {
        return textView
    }

    override func becomeFirstResponder() -> Bool {
        return textView.becomeFirstResponder()
    }

    override func resignFirstResponder() -> Bool {
        return textView.resignFirstResponder()
    }
    
}

