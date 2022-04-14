//
//  CustomBrowserViewController.swift
//  IOKA
//
//  Created by ablai erzhanov on 16.03.2022.
//

import UIKit
import WebKit


internal class ThreeDSecureViewController:  UIViewController, UIScrollViewDelegate {
    
    var viewModel: ThreeDSecureViewModel!
    var url: URL!
    var theme: IokaTheme!
    var webView = WKWebView()
    var navView = IokaBrowserNavigationView()
    private lazy var loadingIndicator = IokaProgressView()
    private lazy var errorView = ErrorToastView()
    
    override func loadView() {
        super.loadView()
        self.view.addSubview(navView)
        self.view.addSubview(webView)
        self.view.addSubview(loadingIndicator)
        self.view.addSubview(errorView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        navView.anchor(top: self.view.topAnchor, left: self.view.leftAnchor, right: self.view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingRight: 0, height: 100)
        webView.anchor(top: navView.bottomAnchor, left: self.view.leftAnchor, bottom: self.view.bottomAnchor, right: self.view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
        loadingIndicator.center(in: self.view, in: self.view, width: 80, height: 80)
        
        errorView.anchor(left: self.view.leftAnchor, bottom: self.view.bottomAnchor, right: self.view.rightAnchor, paddingLeft: 16, paddingBottom: 114, paddingRight: 16)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.webView.addObserver(self, forKeyPath: #keyPath(WKWebView.isLoading), options: .new, context: nil)
        navView.backgroundColor = theme.colors.background
        self.view.backgroundColor = theme.colors.background
        loadingIndicator.startIndicator()
        navView.delegate = self
        webView.scrollView.delegate = self
        webView.navigationDelegate = self
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = false
        handleViewModelCalllbacks()
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
    
    func handleViewModelCalllbacks() {
        viewModel.showError = { [weak self] error in
            guard let self = self else { return }
            self.errorView.show(error: error)
            self.loadingIndicator.stopIndicator()
        }
    }
    
    func hideWebViewWithLoader() {
        self.webView.isHidden = true
        loadingIndicator.isHidden = false
    }
}

extension ThreeDSecureViewController: WKNavigationDelegate, IokaBrowserNavigationViewDelegate  {
    func closeBrowser() {
        viewModel.delegate?.dismissThreeDSecure()
    }
    
    func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        
        hideWebViewWithLoader()
        
        if viewModel.checkReturnUrl(webView.url) {
            DispatchQueue.main.async {
                self.viewModel.handleRedirect()
            }
        }
    }
}
