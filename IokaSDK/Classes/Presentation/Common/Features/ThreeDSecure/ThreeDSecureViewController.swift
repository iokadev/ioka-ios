//
//  ThreeDSecureViewController.swift
//  IOKA
//
//  Created by ablai erzhanov on 16.03.2022.
//

import UIKit
import WebKit


internal class ThreeDSecureViewController: UIViewController, UIScrollViewDelegate {
    
    var viewModel: ThreeDSecureViewModel!
    var webView = WKWebView()
    private lazy var loadingIndicator = IokaProgressView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationItem()

        self.view.addSubview(webView)
        self.view.addSubview(loadingIndicator)
        
        self.webView.addObserver(self, forKeyPath: #keyPath(WKWebView.isLoading), options: .new, context: nil)
        self.view.backgroundColor = colors.background
        loadingIndicator.startIndicator()
        webView.scrollView.delegate = self
        webView.navigationDelegate = self
        webView.load(URLRequest(url: viewModel.action.url))
        webView.allowsBackForwardNavigationGestures = false
        
        webView.anchor(top: self.view.safeAreaTopAnchor, left: self.view.leftAnchor, bottom: self.view.safeAreaBottomAnchor, right: self.view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
        loadingIndicator.center(in: self.view, in: self.view, width: 80, height: 80)
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
    
    private func setupNavigationItem() {
        setupNavigationItem(title: IokaLocalizable.paymentConfirmation,
                            closeButtonTarget: self,
                            closeButtonAction: #selector(closeButtonTapped))
    }
    
    @objc private func closeButtonTapped() {
        viewModel.close()
    }
    
    deinit {
        self.webView.removeObserver(self, forKeyPath: #keyPath(WKWebView.isLoading), context: nil)
    }
    
    func hideWebViewWithLoader() {
        self.webView.isHidden = true
        loadingIndicator.isHidden = false
    }
}

extension ThreeDSecureViewController: WKNavigationDelegate  {
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        guard viewModel.isReturnUrl(navigationAction.request.url) else {
            decisionHandler(.allow)
            return
        }
        
        decisionHandler(.cancel)
        
        hideWebViewWithLoader()
        viewModel.handleRedirect()
    }
}
