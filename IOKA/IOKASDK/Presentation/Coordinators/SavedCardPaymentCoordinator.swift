//
//  PaymentWithSavedCardCoordinator.swift
//  IOKA
//
//  Created by ablai erzhanov on 03.04.2022.
//

import UIKit

protocol Coordinator: NSObject {
    var children: [Coordinator] { get }
    var navigationViewController: UINavigationController { get }
    var childrenViewControllers: [UIViewController] { get }
    func startFlow(coordinator: Coordinator)
    func finishFlow(coordinator: Coordinator)
}

protocol SavedCardPaymentNavigationDelegate: NSObject {
    func dismissView()
    func completeSavedCardPaymentFlow(status: PaymentResult, error: IokaError?, response: CardPaymentResponse?)
}


class SavedCardPaymentCoordinator: NSObject, Coordinator {
    
    let navigationViewController: UINavigationController
    var children: [Coordinator] = []
    var childrenViewControllers: [UIViewController] = []
    var card: GetCardResponse?
    var orderAccessToken: String?
    let routerCoordinator: RouterCoordinator
    var url: String?
    var iokaBrowserState: IokaBrowserState?
    var paymentResult: PaymentResult?
    var error: IokaError?
    var response: CardPaymentResponse?
    
    var topViewController: UIViewController!
    
    private lazy var savedCardPaymentViewControlller: SavedCardPaymentViewControlller = {
        guard let card = card, let orderAccessToken = orderAccessToken else { fatalError("Card information weren't provided") }

        return IokaFactory.shared.initiateSavedCardPaymentViewController(orderAccessToken: orderAccessToken, card: card, delegate: self)
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
    
    func showSavedCardPaymentForm() {
        routerCoordinator.presentViewController(savedCardPaymentViewControlller, animated: false, completion: nil)
    }
    
    func dismissSavedCardPaymentForm() {
        self.routerCoordinator.dismissViewController(animated: false, completion: nil)
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

extension SavedCardPaymentCoordinator: SavedCardPaymentNavigationDelegate, IokaBrowserViewControllerDelegate, PaymentResultNavigationDelegate {
    
    func dismissView() {
        self.dismissSavedCardPaymentForm()
    }
    
    func completeSavedCardPaymentFlow(status: PaymentResult, error: IokaError?, response: CardPaymentResponse?) {
        if let response = response, let actionURL = response.action?.url {
            self.url = "\(actionURL)?return_url=https://ioka.kz"
            self.iokaBrowserState = .createCardPayment(orderId: response.order_id, paymentId: response.id)
            self.show3DSecure()
            self.dismissSavedCardPaymentForm()
        } else {
            self.paymentResult = status
            self.error = error
            self.response = response
            self.showPaymentResult()
            self.dismissSavedCardPaymentForm()
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

