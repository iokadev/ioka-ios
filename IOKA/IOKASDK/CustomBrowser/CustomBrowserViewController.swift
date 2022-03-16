//
//  CustomBrowserViewController.swift
//  IOKA
//
//  Created by ablai erzhanov on 16.03.2022.
//

import Foundation
import UIKit
import WebKit

protocol CustomBrowserViewControllerDelegate: NSObject {
    func closeCustomBrowserViewController(_ viewController: UIViewController, customBrowserState: CustomBrowserState, cardPaymentResponse: CardPaymentResponse?, getCardResponse: GetCardResponse?, error: CustomError?)
}

class CustomBrowserViewController:  UIViewController {
    
    var webView = WKWebView()
    var url: URL!
    var customBrowserState: CustomBrowserState!
    weak var delegate: CustomBrowserViewControllerDelegate?
    
    override func loadView() {
        super.loadView()
        self.view.backgroundColor = .yellow
        webView.navigationDelegate = self
        self.view.addSubview(webView)
        webView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = false
    }
}

extension CustomBrowserViewController: WKNavigationDelegate  {
    func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            
            switch self.customBrowserState {
            case .createCardPayment(let orderId, let paymentId):
                IokaApi.shared.getPaymentByID(orderId: orderId, paymentId: paymentId) { [weak self] response, error in
                    guard let self = self else { return }
                    DispatchQueue.main.async {
                        self.delegate?.closeCustomBrowserViewController(self, customBrowserState: self.customBrowserState, cardPaymentResponse: response, getCardResponse: nil, error: error)
                    }
                }
            case .createBinding(let customerId, let cardId):
                IokaApi.shared.getCardByID(customerId: customerId, cardId: cardId) { [weak self] response, error in
                    guard let self = self else { return }
                    DispatchQueue.main.async {
                        self.delegate?.closeCustomBrowserViewController(self, customBrowserState: self.customBrowserState, cardPaymentResponse: nil, getCardResponse: response, error: error)
                    }
                }
            case .none:
                print("Hello")
            }
        }
    }
}
