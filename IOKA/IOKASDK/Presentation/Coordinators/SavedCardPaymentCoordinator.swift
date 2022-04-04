//
//  PaymentWithSavedCardCoordinator.swift
//  IOKA
//
//  Created by ablai erzhanov on 03.04.2022.
//

import UIKit

protocol SavedCardPaymentNavigationDelegate: NSObject {
    func dismissView()
    func completeSavedCardPaymentFlow(status: PaymentResult, error: IokaError?, response: CardPaymentResponse?)
}


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
    
    private lazy var errorPopUpViewController: ErrorPopUpViewController = {
        guard let error = error else { fatalError("Please provide IokaError to show error pop up view") }
        return IokaFactory.shared.initiateErrorPopUpViewController(delegate: self, error: error)
    }()
    
    private lazy var createPaymentForSavedCardViewModel: CreatePaymentForSavedCardViewModel = {
        guard let card = card, let orderAccessToken = orderAccessToken else { fatalError("Card information weren't provided") }
        return IokaFactory.shared.initiateCreatePaymentForSavedCardViewModel(card: card, orderAccessToken: orderAccessToken, delegate: self)
    }()
    
    private lazy var progressWrapperView = IokaFactory.shared.initiateProgressWrapperView(state: .payment)
    
    init(navigationViewController: UINavigationController) {
        self.navigationViewController = navigationViewController
        self.routerCoordinator = RouterNavigation(navigationViewController: navigationViewController)
        super.init()
    }
    
    func startFlow() {
        guard let card = card else { return }
        switch card.cvc_required {
        case true:
            showSavedCardPaymentForm()
        case false:
            showSavedCardPaymentForm()
        }
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
    
    func showViewControllerProgressWrapper() {
        self.topViewController.view = progressWrapperView
    }
    
    func dismissViewControllerProgressWrapper() {
        progressWrapperView.stop()
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
            } else if let error = cardPaymentResponse?.error {
                self.paymentResult = .paymentFailed
                self.error = error
                self.response = cardPaymentResponse
                self.showErrorPopUp()
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
    
    func dismiss() {
        dismissErrorPopUp()
    }
    
}


extension SavedCardPaymentCoordinator: CreatePaymentForSavedCardNavigationDelegate {
    func paymentCreated(response: CardPaymentResponse?, error: IokaError?, status: PaymentResult) {
        if let response = response, let actionURL = response.action?.url {
            self.url = "\(actionURL)?return_url=https://ioka.kz"
            self.iokaBrowserState = .createCardPayment(orderId: response.order_id, paymentId: response.id)
            self.show3DSecure()
            dismissViewControllerProgressWrapper()
        } else {
            self.paymentResult = status
            self.error = error
            self.response = response
            self.showPaymentResult()
            dismissViewControllerProgressWrapper()
        }
    }
}

