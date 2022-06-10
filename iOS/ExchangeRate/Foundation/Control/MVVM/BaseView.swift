//
//  BaseView.swift
//  Base
//
//  Created by pineone on 2021/08/04.
//

import RxCocoa
import RxSwift
import SnapKit
import Then
import UIKit

class BaseView: UIView {
    var naviType: BaseNavigationShowType = .none
    lazy var naviBar = BaseNavigationBar(type: self.naviType)

    init(naviType: BaseNavigationShowType) {
        super.init(frame: .zero)
        backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        self.naviType = naviType

        if naviType != .none {
            addSubview(naviBar)
            naviBar.snp.makeConstraints {
                $0.top.leading.trailing.equalToSuperview()
                $0.height.equalTo(naviBar.navBarHeight + CGFloat(UIDevice.topSafeArea))
            }
        }
    }

    func addSubview(_ view: UIView, needTopMoveButton: Bool = false) {
        addSubview(view)
    }

    func addSubviews(_ views: [UIView], needTopMoveButton: Bool = false) {
        addSubviews(views)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setWholeBackgroundColor(_ color: UIColor) {
        self.backgroundColor = color
        self.naviBar.backgroundColor = color
    }
}
