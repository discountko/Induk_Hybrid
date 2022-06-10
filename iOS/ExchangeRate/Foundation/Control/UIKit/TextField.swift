//
//  TextField.swift
//  ExchangeRate
//
//  Created by pineone on 2022/04/18.
//

import UIKit

class TextField: UITextField {
    var maximumTextLength: Int = 0

    var paddingLeftCustom: CGFloat {
        get {
            return leftView!.frame.size.width
        }
        set {
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: newValue, height: frame.size.height))
            leftView = paddingView
            leftViewMode = .always
        }
    }

    var paddingRightCustom: CGFloat {
        get {
            return rightView!.frame.size.width
        }
        set {
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: newValue, height: frame.size.height))
            rightView = paddingView
            rightViewMode = .always
        }
    }

    override func didMoveToWindow() {
        super.didMoveToWindow()
        addTarget(self, action: #selector(handleEditingChanged(_:)), for: .editingChanged)
    }

    @objc func handleEditingChanged(_ sender: TextField) {
        guard let text = text else {
            return
        }
        guard maximumTextLength > 0 && text.utf16.count > maximumTextLength else {
            return
        }
        deleteBackward()
    }
    
    func setPasswordType() {
        isSecureTextEntry = true
        cornerRadius = 4
        borderColor = #colorLiteral(red: 0.8784313725, green: 0.8784313725, blue: 0.8784313725, alpha: 1)
        borderWidth = 1
        font = .notoSans(size: 14)
        textColor = #colorLiteral(red: 0.1333333333, green: 0.1333333333, blue: 0.1333333333, alpha: 1)
        paddingLeftCustom = 12
        paddingRightCustom = 12
        maximumTextLength = 6
        keyboardType = .numberPad
        tintColor = #colorLiteral(red: 0.1333333333, green: 0.1333333333, blue: 0.1333333333, alpha: 0.5)
        textAlignment = .center
    }
}
