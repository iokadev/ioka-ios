//
//  CustomBrowserViewController.swift
//  IOKA
//
//  Created by ablai erzhanov on 16.03.2022.
//

import Foundation
import UIKit
import WebKit

protocol IokaBrowserViewControllerDelegate: NSObject {
    func closeIokaBrowserViewController(_ viewController: UIViewController, iokaBrowserState: IokaBrowserState, cardPaymentResponse: CardPaymentResponse?, getCardResponse: GetCardResponse?, error: IokaError?)
    func closeIokaBrowserViewController(_ viewController: UIViewController)
}

class IokaBrowserViewController:  IokaViewController {
    
    var webView = WKWebView()
    var navView = IokaBrowserNavigationView()
    private lazy var loadingIndicator = IokaProgressView()
    var url: URL!
    var iokaBrowserState: IokaBrowserState!
    weak var delegate: IokaBrowserViewControllerDelegate?
    
    override func loadView() {
        super.loadView()
        navView.backgroundColor = IOKA.shared.theme.background
        self.view.backgroundColor = IOKA.shared.theme.background
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

extension IokaBrowserViewController: WKNavigationDelegate, IokaBrowserNavigationViewDelegate  {
    func closeBrowser() {
        delegate?.closeIokaBrowserViewController(self)
    }
    
    func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        
        self.webView.isHidden = true
        loadingIndicator.isHidden = false
    
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            guard let iokaBrowserState = self.iokaBrowserState else { return }
            
            switch iokaBrowserState {
            case .createCardPayment(let orderId, let paymentId):
                IokaApi.shared.getPaymentByID(orderId: orderId, paymentId: paymentId) { [weak self] response, error in
                    guard let self = self else { return }
                    DispatchQueue.main.async {
                        self.delegate?.closeIokaBrowserViewController(self, iokaBrowserState: self.iokaBrowserState, cardPaymentResponse: response, getCardResponse: nil, error: error)
                    }
                }
            case .createBinding(let customerId, let cardId):
                IokaApi.shared.getCardByID(customerId: customerId, cardId: cardId) { [weak self] response, error in
                    guard let self = self else { return }
                    DispatchQueue.main.async {
                        self.delegate?.closeIokaBrowserViewController(self, iokaBrowserState: self.iokaBrowserState, cardPaymentResponse: nil, getCardResponse: response, error: error)
                    }
                }
            }
        }
    }
}
