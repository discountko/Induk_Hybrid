//
//  WKWebView+Rx.swift
//  AISAR
//
//  Created by baedy on 2020/11/17.
//  Copyright © 2020 Pineone. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit
import WebKit

enum WKState {
    case start
    case finish
    case fail(Error)
}

extension Reactive where Base: WKWebView {
    fileprivate var navigationDelegate: RxWKNavigationDelegateProxy {
        return RxWKNavigationDelegateProxy.proxy(for: base)
    }

    public var decidePolicy: Observable<(WKWebView, WKNavigationAction, ((WKNavigationActionPolicy) -> Swift.Void))> {
        return navigationDelegate.decidePolicySubject.asObserver()
    }

    var naviState: Observable<(WKWebView, WKNavigation, WKState)> {
        return navigationDelegate.stateWebview.asObserver()
    }
}

class RxWKNavigationDelegateProxy: DelegateProxy<WKWebView, WKNavigationDelegate>, DelegateProxyType, WKNavigationDelegate {
    let decidePolicySubject = PublishSubject<(WKWebView, WKNavigationAction, ((WKNavigationActionPolicy) -> Swift.Void))>()

    let stateWebview = PublishSubject<(WKWebView, WKNavigation, WKState)>()

    open class func currentDelegate(for object: WKWebView) -> WKNavigationDelegate? {
        return object.navigationDelegate
    }

    open class func setCurrentDelegate(_ delegate: WKNavigationDelegate?, to object: WKWebView) {
        object.navigationDelegate = delegate
    }

    public init(webView: WKWebView) {
        super.init(parentObject: webView, delegateProxy: RxWKNavigationDelegateProxy.self)
    }

    static func registerKnownImplementations() {
        self.register { RxWKNavigationDelegateProxy(webView: $0) }
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        stateWebview.onNext((webView, navigation, .finish))
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        stateWebview.onNext((webView, navigation, .fail(error)))
    }

    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        stateWebview.onNext((webView, navigation, .start))
    }

    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        stateWebview.onNext((webView, navigation, .fail(error)))
    }

    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        decidePolicySubject.onNext((webView, navigationAction, decisionHandler))
    }
}
