//
//  CardPaymentCoordinator.swift
//  IOKA
//
//  Created by ablai erzhanov on 03.04.2022.
//

import UIKit

//protocol CardPaymentNavigationDelegate: NSObject {
//    func completeCardPaymentForm(status: PaymentResult, error: IokaError?, response: CardPaymentResponse?)
//    func completeCardPaymentForm()
//}

//class CardPaymentCoordinator: NSObject, Coordinator {
//
//    let navigationViewController: UINavigationController
//    var children: [Coordinator] = []
//    var childrenViewControllers: [UIViewController] = []
//    let routerCoordinator: RouterCoordinator
//    var url: String?
//    var iokaBrowserState: IokaBrowserState?
//    var paymentResult: PaymentResult?
//    var error: IokaError?
//    var paymentResponse: CardPaymentResponse?
//    var orderAccessToken: String?
//    var orderResponse: GetOrderResponse?
//
//    var topViewController: UIViewController!
//
//    private lazy var cardPaymentViewController: CardPaymentViewController = {
//        guard let order = orderResponse else { fatalError("Please provide order to construct CardPaymentViewController") }
//
//        return IokaFactory.shared.initiateCardPaymentViewController(orderAccesToken: IOKA.shared.orderAccessToken, delegate: self, order: order)
//    }()
//
//    private lazy var iokaBrowserViewController: IokaBrowserViewController = {
//        guard let url = url, let iokaBrowserState = iokaBrowserState else { fatalError("Please provide action Url or IokaBrowserState") }
//        return IokaFactory.shared.initiateIokaBrowserViewController(url: url, delegate: self, iokaBrowserState: iokaBrowserState)
//    }()
//
//    private lazy var paymentResultViewController: PaymentResultViewController = {
//        guard let paymentResult = paymentResult else { fatalError("Please provide paymentResult") }
//        guard let order = orderResponse else { fatalError("Please provide order to construct CardPaymentViewController") }
//        return IokaFactory.shared.initiatePaymentResultViewController(paymentResult: paymentResult, error: self.error, response: self.paymentResponse, delegate: self, order: order)
//    }()
//
//    private lazy var getOrderForPaymentViewController: GetOrderForPaymentViewController = {
//        guard let orderAccessToken = orderAccessToken else { fatalError("Order Access token wasn't provided") }
//        return IokaFactory.shared.initiateGetOrderForPaymentViewController(delegate: self, orderId: orderAccessToken.trimTokens())
//    }()
//
//    init(navigationViewController: UINavigationController) {
//        self.navigationViewController = navigationViewController
//        self.routerCoordinator = RouterNavigation(navigationViewController: navigationViewController)
//        super.init()
//    }
//
//    func startFlow() {
//        self.showViewControllerProgressWrapper()
//    }
//
//    func finishFlow(coordinator: Coordinator) {
//        self.navigationViewController.popToViewController(topViewController, animated: true)
//    }
//
//    func showCardPaymentForm() {
//        routerCoordinator.startFlow(cardPaymentViewController)
//    }
//
//    func dismissCardPaymentForm() {
//        self.navigationViewController.viewControllers = self.navigationViewController.viewControllers.filter { $0 != cardPaymentViewController }
//    }
//
//    func show3DSecure() {
//        routerCoordinator.startFlow(iokaBrowserViewController)
//    }
//
//    func dismiss3DSecure() {
//        self.navigationViewController.viewControllers = self.navigationViewController.viewControllers.filter { $0 != iokaBrowserViewController }
//    }
//
//    func showPaymentResult() {
//        routerCoordinator.startFlow(paymentResultViewController)
//    }
//
//    func dismissPaymentResult() {
//        self.navigationViewController.viewControllers = self.navigationViewController.viewControllers.filter { $0 != paymentResultViewController }
//    }
//
//    func showViewControllerProgressWrapper() {
//        routerCoordinator.presentViewController(getOrderForPaymentViewController, animated: false, completion: nil)
//    }
//
//    func dismissViewControllerProgressWrapper() {
//        routerCoordinator.dismissViewController(animated: false, completion: nil)
//    }
//}

//extension CardPaymentCoordinator: CardPaymentNavigationDelegate, IokaBrowserViewControllerDelegate, PaymentResultNavigationDelegate {
//
//    func completeCardPaymentForm() {
//        self.dismissCardPaymentForm()
//    }
//
//    func completeCardPaymentForm(status: PaymentResult, error: IokaError?, response: CardPaymentResponse?) {
//        if let response = response, let actionURL = response.action?.url {
//            self.url = "\(actionURL)?return_url=https://ioka.kz"
//            self.iokaBrowserState = .createCardPayment(orderId: response.order_id, paymentId: response.id)
//            self.show3DSecure()
//            self.dismissCardPaymentForm()
//        } else {
//            self.paymentResult = status
//            self.error = error
//            self.paymentResponse = response
//            self.showPaymentResult()
//            self.dismissCardPaymentForm()
//        }
//    }
//
//    func closeIokaBrowserViewController(_ viewController: UIViewController) {
//        self.dismiss3DSecure()
//    }
//
//    func closeIokaBrowserViewController(_ viewController: UIViewController, iokaBrowserState: IokaBrowserState, cardPaymentResponse: CardPaymentResponse?, getCardResponse: GetCardResponse?, error: IokaError?) {
//        switch iokaBrowserState {
//        case .createCardPayment(_, _):
//
//            if let cardPaymentResponse = cardPaymentResponse, let error = cardPaymentResponse.error {
//                self.paymentResult = .paymentFailed
//                self.error = error
//                self.paymentResponse = cardPaymentResponse
//                self.showPaymentResult()
//                dismiss3DSecure()
//            } else if cardPaymentResponse?.error == nil {
//                self.paymentResult = .paymentSucceed
//                self.error = nil
//                self.paymentResponse = cardPaymentResponse
//                self.showPaymentResult()
//                dismiss3DSecure()
//            } else {
//                self.paymentResult = .paymentFailed
//                self.error = error
//                self.paymentResponse = nil
//                self.showPaymentResult()
//                dismiss3DSecure()
//            }
//        case .createBinding( _, _):
//            self.dismiss3DSecure()
//        }
//    }
//
//    func closePaymentResultScreen() {
//        finishFlow(coordinator: self)
//        self.dismissPaymentResult()
//    }
//
//    func retryPaymentProcess() {
//        finishFlow(coordinator: self)
//        self.dismissPaymentResult()
//    }
//}

//extension CardPaymentCoordinator: GetOrderForPaymentNavigationDelegate {
//    func dismissGetOrderProgressWrapper() {
//        DispatchQueue.main.async {
//            self.dismissViewControllerProgressWrapper()
//        }
//    }
//    
//    func gotOrder(order: GetOrderResponse?, error: IokaError?) {
//        DispatchQueue.main.async {
//            self.orderResponse = order
//            self.showCardPaymentForm()
//            self.dismissViewControllerProgressWrapper()
//        }
//    }
//}

