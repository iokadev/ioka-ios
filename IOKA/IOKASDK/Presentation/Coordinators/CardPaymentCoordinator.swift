//
//  CardPaymentCoordinator.swift
//  IOKA
//
//  Created by ablai erzhanov on 03.04.2022.
//

import UIKit

protocol CardPaymentNavigationDelegate: NSObject {
    func completeCardPaymentFlow(status: PaymentResult, error: IokaError?, response: CardPaymentResponse?)
    func completeCardPaymentFlow()
}

class CardPaymentCoordinator: NSObject, Coordinator {
    
    let navigationViewController: UINavigationController
    var children: [Coordinator] = []
    var childrenViewControllers: [UIViewController] = []
    let routerCoordinator: RouterCoordinator
    var url: String?
    var iokaBrowserState: IokaBrowserState?
    var paymentResult: PaymentResult?
    var error: IokaError?
    var response: CardPaymentResponse?
    
    var topViewController: UIViewController!
    
    private lazy var cardPaymentViewController: CardPaymentViewController = {
        IokaFactory.shared.initiateCardPaymentViewController(orderAccesToken: IOKA.shared.orderAccessToken, delegate: self)
    }()
    
    private lazy var iokaBrowserViewController: IokaBrowserViewController = {
        guard let url = url, let iokaBrowserState = iokaBrowserState else { fatalError("Please provide action Url or IokaBrowserState") }
        return IokaFactory.shared.initiateIokaBrowserViewController(url: url, delegate: self, iokaBrowserState: iokaBrowserState)
    }()
    
    private lazy var paymentResultViewController: PaymentResultViewController = {
        guard let paymentResult = paymentResult else { fatalError("Please provide paymentResult") }
        return IokaFactory.shared.initiatePaymentResultViewController(paymentResult: paymentResult, error: self.error, response: self.response, delegate: self)
    }()
    
    init(navigationViewController: UINavigationController) {
        self.navigationViewController = navigationViewController
        self.routerCoordinator = RouterNavigation(navigationViewController: navigationViewController)
        super.init()
    }
    
    func startFlow(coordinator: Coordinator) {
        self.children.append(coordinator)
    }
    
    func finishFlow(coordinator: Coordinator) {
        self.navigationViewController.popToViewController(topViewController, animated: true)
    }
    
    func showCardPaymentForm() {
        routerCoordinator.startFlow(cardPaymentViewController)
    }
    
    func dismissCardPaymentForm() {
        self.navigationViewController.viewControllers = self.navigationViewController.viewControllers.filter { $0 != cardPaymentViewController }
    }
    
    func show3DSecure() {
        routerCoordinator.startFlow(iokaBrowserViewController)
    }
    
    func dismiss3DSecure() {
        self.navigationViewController.viewControllers = self.navigationViewController.viewControllers.filter { $0 != iokaBrowserViewController }
    }
    
    func showPaymentResult() {
        routerCoordinator.startFlow(paymentResultViewController)
    }
    
    func dismissPaymentResult() {
        self.navigationViewController.viewControllers = self.navigationViewController.viewControllers.filter { $0 != paymentResultViewController }
    }
}

extension CardPaymentCoordinator: CardPaymentNavigationDelegate, IokaBrowserViewControllerDelegate, PaymentResultNavigationDelegate {
    
    func completeCardPaymentFlow() {
        self.dismissCardPaymentForm()
    }
    
    func completeCardPaymentFlow(status: PaymentResult, error: IokaError?, response: CardPaymentResponse?) {
        if let response = response, let actionURL = response.action?.url {
            self.url = "\(actionURL)?return_url=https://ioka.kz"
            self.iokaBrowserState = .createCardPayment(orderId: response.order_id, paymentId: response.id)
            self.show3DSecure()
            self.dismissCardPaymentForm()
        } else {
            self.paymentResult = status
            self.error = error
            self.response = response
            self.showPaymentResult()
            self.dismissCardPaymentForm()
        }
    }
    
    func closeIokaBrowserViewController(_ viewController: UIViewController) {
        self.dismiss3DSecure()
    }
    
    func closeIokaBrowserViewController(_ viewController: UIViewController, iokaBrowserState: IokaBrowserState, cardPaymentResponse: CardPaymentResponse?, getCardResponse: GetCardResponse?, error: IokaError?) {
        switch iokaBrowserState {
        case .createCardPayment(_, _):
            if let cardPaymentResponse = cardPaymentResponse, cardPaymentResponse.error == nil {
                self.paymentResult = .paymentSucceed
                self.error = nil
                self.response = cardPaymentResponse
                self.showPaymentResult()
            } else {
                self.paymentResult = .paymentFailed
                self.error = nil
                self.response = cardPaymentResponse
                self.showPaymentResult()
            }
            if let error = error {
                self.paymentResult = .paymentFailed
                self.error = error
                self.response = nil
                self.showPaymentResult()
            }
            self.dismiss3DSecure()
        case .createBinding( _, _):
            self.dismiss3DSecure()
        }
    }
    
    func closePaymentResultViewController() {
        finishFlow(coordinator: self)
        self.dismissPaymentResult()
    }

    func retryPaymentProcess() {
        finishFlow(coordinator: self)
        self.dismissPaymentResult()
    }
}

