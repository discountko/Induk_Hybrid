//
//  NewsView.swift
//  Basic
//
//  Created by pineone on 2021/09/16.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

class NewsView: UIBasePreviewType {
    
    // MARK: - Model type implemente
    typealias Model = Void
    
    // MARK: - init
    override init(naviType: BaseNavigationShowType = .none) {
        super.init(naviType: naviType)
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View
    lazy var loginButton = UIButton().then {
        $0.setTitle("로그인", for: .normal)
        $0.setBackgroundColor(.gray, for: .highlighted)
        $0.cornerRadius = 10
    }
    
    // MARK: - Methods
    func setupLayout() {
        backgroundColor = .white
        
        addSubviews([loginButton])
        
        loginButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(50)
            $0.centerX.equalToSuperview()
        }
        
    }
    
    func setupDI(observable: Observable<[Model]>) {
        // model Dependency Injection
    }
}


// MARK: - PreView
#if canImport(SwiftUI) && DEBUG
import SwiftUI

@available(iOS 13.0, *)
struct MoreSee_Previews: PreviewProvider {
    static var previews: some View {
        //        Group {
        //            ForEach(UIView.previceSupportDevices, id: \.self) { deviceName in
        //                DebugPreviewView {
        //                    return NewsView()
        //                }.previewDevice(PreviewDevice(rawValue: deviceName))
        //                    .previewDisplayName(deviceName)
        //                    .previewLayout(.sizeThatFits)
        //            }
        //        }        
        Group {
            DebugPreviewView {
                let view = NewsView()
                //                .then {
                //                    $0.setupDI(observable: Observable.just([]))
                //                }
                return view
            }
        }
    }
}
#endif
