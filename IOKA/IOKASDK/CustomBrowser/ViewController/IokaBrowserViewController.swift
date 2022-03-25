//
//  IokaBrowserViewController.swift
//  IOKA
//
//  Created by ablai erzhanov on 16.03.2022.
//

import Foundation
import UIKit
import WebKit

protocol IokaBrowserViewControllerDelegate: NSObject {
    func closeIokaBrowserViewController(_ viewController: UIViewController, iokaBrowserState: IokaBrowserState, cardPaymentResponse: CardPaymentResponse?, getCardResponse: GetCardResponse?, error: IokaError?)
}

class IokaBrowserViewController:  UIViewController {
    
    var webView = WKWebView()
    var url: URL!
    var iokaBrowserState: IokaBrowserState!
    weak var delegate: IokaBrowserViewControllerDelegate?
    
    override func loadView() {
        super.loadView()
        self.view.backgroundColor = .yellow
        webView.navigationDelegate = self
        self.view.addSubview(webView)
        webView.fillView(self.view)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = false
    }
}

extension IokaBrowserViewController: WKNavigationDelegate  {
    func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            
            switch self.iokaBrowserState {
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
            case .none:
                print("Hello")
            }
        }
    }
}
