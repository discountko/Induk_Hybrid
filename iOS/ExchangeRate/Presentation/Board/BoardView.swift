//
//  SearchView.swift
//  Basic
//
//  Created by pineone on 2021/09/23.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa
import WebKit

class BoardView: UIBasePreviewType, UIScrollViewDelegate, WKUIDelegate, WKNavigationDelegate {
    
    // MARK: - Model type implemente
    typealias Model = Void
    
    let actionRelay = PublishRelay<BoardActionType>()

    // MARK: - init
    override init(naviType: BaseNavigationShowType = .centerTitleRightLogout) {
        super.init(naviType: naviType)
        naviBar.title = "채팅"
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View
    lazy var webView = WKWebView().then {
        $0.backgroundColor = .white
        $0.scrollView.delegate = self
        $0.navigationDelegate = self
        $0.uiDelegate = self
        $0.allowsBackForwardNavigationGestures = true
        let myUrl = URL(string: "http://0.0.0.0:8000/chat")
        $0.load(URLRequest(url: myUrl!))
    }
    
    /// 로딩 인디게이터
    lazy var indicator = UIActivityIndicatorView(style: .large)
    
    // MARK: - Outlets
    
    // MARK: - Methods
    func setupLayout() {
        backgroundColor = .white
        addSubviews([webView, indicator])
        
        webView.snp.makeConstraints {
            $0.top.equalTo(naviBar.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }

        indicator.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    /// User Input
    @discardableResult
    func setupDI(relay: PublishRelay<BoardActionType>) -> Self {
        actionRelay.bind(to: relay).disposed(by: rx.disposeBag)
        return self
    }
    
//    func setupDI(observable: Observable<String>) {
//        observable.subscribe(onNext: { [weak self] urlString in
//            guard let `self` = self else { return }
//            if urlString.isEmpty {
//                return
//            }
//            if let url = URL(string: urlString) {
//                self.webView.load(URLRequest(url: url))
//            }
//        }).disposed(by: rx.disposeBag)
//    }
    
    func bindData() {
        
    }
}


// MARK: - PreView
#if canImport(SwiftUI) && DEBUG
import SwiftUI

@available(iOS 13.0, *)
struct Search_Previews: PreviewProvider {
    static var previews: some View {
        //        Group {
        //            ForEach(UIView.previceSupportDevices, id: \.self) { deviceName in
        //                DebugPreviewView {
        //                    return BoardView()
        //                }.previewDevice(PreviewDevice(rawValue: deviceName))
        //                    .previewDisplayName(deviceName)
        //                    .previewLayout(.sizeThatFits)
        //            }
        //        }        
        Group {
            DebugPreviewView {
                let view = BoardView()
                //                .then {
                //                    $0.setupDI(observable: Observable.just([]))
                //                }
                return view
            }
        }
    }
}
#endif
