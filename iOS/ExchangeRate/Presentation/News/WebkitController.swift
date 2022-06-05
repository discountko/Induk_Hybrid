//
//  WebkitController.swift
//  ExchangeRate
//
//  Created by gwakgh on 2022/06/02.
//

import UIKit
import WebKit

class WebkitController: UIViewController, WKNavigationDelegate, WKUIDelegate {

    var webView: WKWebView!
    var articleURL: String?
    
    override func loadView() {
        super.loadView()
        webView = WKWebView(frame: self.view.frame)
        self.view = self.webView!
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        let sURL = articleURL!
        let uURL = URL(string: sURL)
        var request = URLRequest(url: uURL!)
        webView.load(request)
    }
}
