//
//  CustomBrowserViewController.swift
//  IOKA
//
//  Created by ablai erzhanov on 16.03.2022.
//

import UIKit
import WebKit


class ThreeDSecureViewController:  IokaViewController {
    
    var viewModel: ThreeDSecureViewModel!
    var url: URL!
    
    var webView = WKWebView()
    var navView = IokaBrowserNavigationView()
    private lazy var loadingIndicator = IokaProgressView()
    
    override func loadView() {
        super.loadView()
        navView.backgroundColor = Ioka.shared.theme.background
        self.view.backgroundColor = Ioka.shared.theme.background
        self.view.addSubview(navView)
        self.view.addSubview(webView)
        self.view.addSubview(loadingIndicator)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        navView.anchor(top: self.view.topAnchor, left: self.view.leftAnchor, right: self.view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingRight: 0, height: 100)
        webView.anchor(top: navView.bottomAnchor, left: self.view.leftAnchor, bottom: self.view.bottomAnchor, right: self.view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
        loadingIndicator.center(in: self.view, in: self.view, width: 80, height: 80)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.webView.addObserver(self, forKeyPath: #keyPath(WKWebView.isLoading), options: .new, context: nil)
        
        loadingIndicator.startIndicator()
        navView.delegate = self
        webView.navigationDelegate = self
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = false
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "loading" {
            if webView.isLoading {
                loadingIndicator.isHidden = false
                loadingIndicator.startIndicator()
            } else {
                loadingIndicator.isHidden = true
            }
        }
    }
    
    deinit {
        self.webView.removeObserver(self, forKeyPath: #keyPath(WKWebView.isLoading), context: nil)
    }
}

extension ThreeDSecureViewController: WKNavigationDelegate, IokaBrowserNavigationViewDelegate  {
    func closeBrowser() {
        viewModel.delegate?.dismissThreeDSecure()
    }
    
    func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        
        self.webView.isHidden = true
        loadingIndicator.isHidden = false
    
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.viewModel.handleRedirect()
        }
    }
}
