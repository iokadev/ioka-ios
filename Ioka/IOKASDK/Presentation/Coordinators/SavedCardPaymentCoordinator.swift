//
//  PaymentWithSavedCardCoordinator.swift
//  IOKA
//
//  Created by ablai erzhanov on 03.04.2022.
//

import UIKit


class SavedCardPaymentCoordinator: NSObject, Coordinator {
    
    let navigationViewController: UINavigationController
    var childrenViewControllers: [UIViewController] = []
    var card: GetCardResponse?
    var orderAccessToken: String?
    let routerCoordinator: RouterCoordinator
    var url: String?
    var iokaBrowserState: IokaBrowserState?
    var paymentResult: PaymentResult?
    var error: IokaError?
    var paymentResponse: CardPaymentResponse?
    var orderResponse: GetOrderResponse?
    
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
        guard let order = orderResponse else { fatalError("Please provide order to construct CardPaymentViewController") }
        return IokaFactory.shared.initiatePaymentResultViewController(paymentResult: paymentResult, error: self.error, response: self.paymentResponse, delegate: self, order: order)
    }()
    
    private lazy var errorPopUpViewController: ErrorPopUpViewController = {
        guard let error = error else { fatalError("Please provide IokaError to show error pop up view") }
        return IokaFactory.shared.initiateErrorPopUpViewController(delegate: self, error: error)
    }()
    
    private lazy var createPaymentForSavedCardViewController: CreatePaymentForSavedCardViewController = {
        guard let card = card, let orderAccessToken = orderAccessToken else { fatalError("Card information weren't provided") }
        return IokaFactory.shared.initiateCreatePaymentForSavedCardViewController(card: card, orderAccessToken: orderAccessToken, delegate: self)
    }()
    
    private lazy var getOrderForPaymentViewController: GetOrderForPaymentViewController = {
        guard let orderAccessToken = orderAccessToken else { fatalError("Order Access token wasn't provided") }
        return IokaFactory.shared.initiateGetOrderForPaymentViewController(delegate: self, orderId: orderAccessToken.trimTokens())
    }()
    
    init(navigationViewController: UINavigationController) {
        self.navigationViewController = navigationViewController
        self.routerCoordinator = RouterNavigation(navigationViewController: navigationViewController)
        super.init()
    }
    
    func startFlow() {
        guard let card = card else { return }
        showViewControllerProgressWrapper(cvcRequired: card.cvc_required)
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
    
    func showErrorPopUp() {
        routerCoordinator.presentViewController(errorPopUpViewController, animated: false, completion: nil)
    }
    
    func dismissErrorPopUp() {
        routerCoordinator.dismissViewController(animated: false, completion: nil)
    }
    
    func showViewControllerProgressWrapper(cvcRequired: Bool) {
        if cvcRequired {
            routerCoordinator.presentViewController(getOrderForPaymentViewController, animated: false, completion: nil)
        } else {
            routerCoordinator.presentViewController(createPaymentForSavedCardViewController, animated: false, completion: nil)
        }
    }
    
    func dismissViewControllerProgressWrapper() {
        routerCoordinator.dismissViewController(animated: false, completion: nil)
    }
}

extension SavedCardPaymentCoordinator: SavedCardPaymentNavigationDelegate, IokaBrowserViewControllerDelegate, PaymentResultNavigationDelegate, ErrorPopUpNavigationDelegate {
    
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
            self.paymentResponse = response
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
            
            if let cardPaymentResponse = cardPaymentResponse, let error = cardPaymentResponse.error {
                self.paymentResult = .paymentFailed
                self.error = error
                self.paymentResponse = cardPaymentResponse
                self.showErrorPopUp()
                dismiss3DSecure()
            } else if cardPaymentResponse?.error == nil {
                self.paymentResult = .paymentSucceed
                self.error = nil
                self.paymentResponse = cardPaymentResponse
                self.showPaymentResult()
                dismiss3DSecure()
            } else {
                self.paymentResult = .paymentFailed
                self.error = error
                self.paymentResponse = nil
                self.showPaymentResult()
                dismiss3DSecure()
            }
        case .createBinding( _, _):
            self.dismiss3DSecure()
        }
    }
    
    func closePaymentResultScreen() {
        finishFlow(coordinator: self)
        self.dismissPaymentResult()
    }

    func retryPaymentProcess() {
        finishFlow(coordinator: self)
        self.dismissPaymentResult()
    }
    
    func dismiss() {
        dismissErrorPopUp()
    }
    
}


extension SavedCardPaymentCoordinator: CreatePaymentForSavedCardNavigationDelegate {
    func dismissCreatePaymentProgressWrapper() {
        DispatchQueue.main.async {
            self.dismissViewControllerProgressWrapper()
        }
    }
    
    func paymentCreated(orderResponse: GetOrderResponse, paymentResponse: CardPaymentResponse?, error: IokaError?, status: PaymentResult) {
        self.paymentResult = status
        self.error = error
        self.paymentResponse = paymentResponse
        self.orderResponse = orderResponse
        dismissViewControllerProgressWrapper()
        
        if let response = paymentResponse, let actionURL = response.action?.url {
            self.url = "\(actionURL)?return_url=https://ioka.kz"
            self.iokaBrowserState = .createCardPayment(orderId: response.order_id, paymentId: response.id)
            self.show3DSecure()
        } else {
            self.showPaymentResult()
        }
    }
}

extension SavedCardPaymentCoordinator: GetOrderForPaymentNavigationDelegate {
    func dismissGetOrderProgressWrapper() {
        DispatchQueue.main.async {
            self.dismissViewControllerProgressWrapper()
        }
    }
    
    func gotOrder(order: GetOrderResponse?, error: IokaError?) {
        DispatchQueue.main.async {
            self.dismissViewControllerProgressWrapper()
            self.orderResponse = order
            self.showSavedCardPaymentForm()
        }
    }
}

