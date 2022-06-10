//
//  CustomTextBase.swift
//  ExchangeRate
//
//  Created by pineone on 2022/04/18.
//

import RxCocoa

/// "CustomTextField, CustomTextView"에서 사용자 입력을 무시하도록 하는 타입
/// emoji를 제외한 타입은  정규식 매칭으로 처리하였다. 아래 정의된 rawValue는 정규식 pattern 값이다!
enum ForbiddenType: String {
    case korean = "가-힣ㄱ-ㅎㅏ-ㅣㆍ"
    case english = "A-Za-z"
    case number = "0-9"
    case space = "\\s"
    case enter = "\\n"
    case specialCharacter = "dummyPatternForSpecialCharacter"
    case emoji = "dummyPatternForEmoji"
    
    func hasSpecialCharacter(_ string: String) -> Bool {
        // 아래 변수에 원본 문자열에서 특수문자가 아닌 문자를 모두 제거했는데 문자가 남으면 특수문자로 간주!
        var remainString = string

        // 1. 패턴으로 "한글,영문,숫자,공백" 문자를 모두 제거한다
        let notSpecialCharacterPatternList = [
            ForbiddenType.korean.rawValue, ForbiddenType.english.rawValue,
            ForbiddenType.number.rawValue, ForbiddenType.space.rawValue, ForbiddenType.enter.rawValue
        ]
        notSpecialCharacterPatternList.forEach {
            remainString = remainString.replacingOccurrences(of: "[\($0)]", with: "", options: .regularExpression, range: nil)
        }
        // 2. 이모지를 모두 제거한다.
        remainString = remainString.stringByRemovingEmoji()
        
        return !remainString.isEmpty
    }
    
    func hasForbiddenCharacter(_ string: String) -> Bool {
        switch self {
        case .space: fallthrough
        case .enter: fallthrough
        case .number: fallthrough
        case .korean: fallthrough
        case .english: return hasPatternCharacter(string, pattern: self.rawValue)
        case .specialCharacter: return hasSpecialCharacter(string)
        case .emoji: return string.isContainEmoji
        }
    }
    
    private func hasPatternCharacter(_ string: String, pattern: String) -> Bool {
        return NSPredicate(format: "SELF MATCHES %@", "(.*)[\(pattern)](.*)").evaluate(with: string)
    }
}

class CustomTextBase: UIView {
    /// didChange 텍스트 필드 텍스트
    let afterText = BehaviorRelay<String>(value: "")
    /// shouldChangeCharactersIn시점 텍스트 필드 텍스트
    let beforeText = BehaviorRelay<String>(value: "")
    /// shouldChangeCharactersIn시점
    let textRange = BehaviorRelay<UITextRange?>(value: nil)
    
    /// 입력제한 type 전체를 보관
    private var inputForbiddenTypeList = [ForbiddenType]()
    
    /// 토스트 팝업 띄우기
    private var isShowWarningToast = false
    
    /// 처음이 스페이스 또는 엔터 입력 방지
    private var isPreventFirstSpaceNReturn = false
    
    /// text changed callback
    var customTextChangedAction: ((String) -> Void)? = nil
    
    /// maxLength over event callback
    var customTextOveredMaxLengthAction: ((Bool) -> Void)? = nil
    
    /// 전달된 string에서 inputForbiddenTypeList의 FrbiddenType에 해당하는게 있는지 찾아서 리턴한다.
    private func getForbiddenCharacterType(_ string: String) -> ForbiddenType? {
        for currForbiddenType in inputForbiddenTypeList {
            if currForbiddenType.hasForbiddenCharacter(string) {
                return currForbiddenType
            }
        }
        return nil
    }
    
    func hasForbiddenCharacter(_ string: String) -> Bool {
        let forbiddenCharacterType = getForbiddenCharacterType(string)
        if let forbiddenCharacterType = forbiddenCharacterType {
            if isShowWarningToast {
                let toastMessage: String
                switch forbiddenCharacterType {
                case .space: toastMessage = R.String.forbiddenForSpace
                case .enter: toastMessage = ""
                case .number: toastMessage = R.String.forbiddenForNumber
                case .korean: toastMessage = R.String.forbiddenForKorean
                case .english: toastMessage = R.String.forbiddenForEnglish
                case .specialCharacter: toastMessage = R.String.forbiddenForSpecialCharacter
                case .emoji: toastMessage = R.String.forbiddenForEmoji
                }
                if !toastMessage.isEmpty {
                    //Toast.show(toastMessage)
                }
            }
            return true
        } else {
            return false
        }
    }
}

extension CustomTextBase {

    /// text 변경 callback 등록
    func setCustomTextChangedAction(_ handler: ((String) -> Void)?) {
        customTextChangedAction = handler
    }
    
    /// maxLength over event callback 설정
    /// handler param Bool은 방금 max를 over한 것인지 여부이다!
    func setCustomTextOveredMaxLengthAction(_ handler: ((Bool) -> Void)?) {
        customTextOveredMaxLengthAction = handler
    }
    
    /// 입력금지타입 설정
    func addInputForbiddenTypeList(inputForbiddenTypes: [ ForbiddenType ], showToast: Bool = false) {
        inputForbiddenTypeList.removeAll()
        isShowWarningToast = showToast
        inputForbiddenTypes.forEach {
            inputForbiddenTypeList.append($0)
        }
    }
    
    func setPreventFirstSpaceNReturn(_ preventFirstSpaceNReturn: Bool = true) {
        isPreventFirstSpaceNReturn = preventFirstSpaceNReturn
    }

    func setText(_ text: String) {
        if let textView = (self as? CustomTextView)?.getTextView() {
            textView.text = text
        } else if let textField = (self as? CustomTextField)?.getTextField() {
            textField.text = text
        }
    }
    
    func moveCursorToEnd() {
        var selectedTextRange: UITextRange? = nil
        if let textView = (self as? CustomTextView)?.getTextView() {
            selectedTextRange = textView.textRange(from: textView.endOfDocument, to: textView.endOfDocument)
        } else if let textField = (self as? CustomTextField)?.getTextField() {
            selectedTextRange = textField.textRange(from: textField.endOfDocument, to: textField.endOfDocument)
        }
        setSelectedTextRange(selectedTextRange: selectedTextRange)
    }

    func setSelectedTextRange(selectedTextRange: UITextRange?) {
        DispatchQueue.main.async { [weak self] in
            guard let `self` = self else { return }
            if let textView = (self as? CustomTextView)?.getTextView() {
                textView.selectedTextRange = selectedTextRange
            } else if let textField = (self as? CustomTextField)?.getTextField() {
                textField.selectedTextRange = selectedTextRange
            }
        }
    }

}

extension CustomTextBase {
    func checkMaxLength(before: String, after: String, maxLength: Int?, maxLine: Int?) {

        var modify_after = after
        var willSetText = false

        // 처음이 스페이스 또는 엔터 입력 방지를 위해 문자인곳까지 제거
        if isPreventFirstSpaceNReturn {
            if modify_after.hasPrefix(" ") || modify_after.hasPrefix("\n") {
                var firstCharacterPos = 0
                for nIdx in 0..<modify_after.count {
                    let character = modify_after[modify_after.index(modify_after.startIndex, offsetBy: nIdx)]
                    if character == " " || character == "\n" {
                        firstCharacterPos = nIdx
                    } else {
                        break
                    }
                }
                if firstCharacterPos + 1 < modify_after.count {
                    modify_after = modify_after.substring(from: firstCharacterPos + 1)
                } else {
                    modify_after = ""
                }
                willSetText = true
            }
        }
        
        if willSetText {
            setText(modify_after)
        }
    }
    
    // 반올림
    func roundUp(_ x1:CGFloat, _ x2:CGFloat) -> Int {
        var result = Int(x1 / x2)
        if x1.truncatingRemainder(dividingBy: x2) >= 0.5 {
            result += 1
        }
        return result
    }
    
    // 폰트 높이로 계산하여 UITextView 의 라인수 가져오기
    func getTextViewLine(_ _text:String, textView _textView:UITextView) -> Int {
        let frame = NSString(string: _text).boundingRect(
            with: CGSize(width: _textView.contentSize.width, height: .infinity),
            options: [.usesFontLeading, .usesLineFragmentOrigin],
            attributes: [.font : _textView.font ?? UIFont.systemFont(ofSize: 17)],
            context: nil)
        return self.roundUp(frame.size.height, _textView.font!.lineHeight)
    }
}

