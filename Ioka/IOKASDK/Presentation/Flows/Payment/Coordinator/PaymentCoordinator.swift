//
//  PaymentCoordinator.swift
//  Ioka
//
//  Created by ablai erzhanov on 05.04.2022.
//

import UIKit


class PaymentCoordinator: NSObject {
    let factory: PaymentFlowFactory
    let navigationController: UINavigationController
    private var order: Order?
    
    var paymentMethodsViewController: PaymentMethodsViewController?
    var paymentResultViewController: PaymentResultViewController?
    var viewControllerProgressWrapper: ViewControllerProgressWrapper?
    var threeDSecureViewController: ThreeDSecureViewController?
    
    init(factory: PaymentFlowFactory, navigationController: UINavigationController) {
        self.factory = factory
        self.navigationController = navigationController
    }
    
    func start() {
        showViewControllerProgressWrapperFlow()
    }
    
    // REVIEW: думаю, слово flow не нужно в методах ниже. они же не flow, а features. Поэтому либо show...Feature, либо без ничего, типа showPaymentMethods.
    
    // REVIEW: showOrderForPayment()
    func showViewControllerProgressWrapperFlow() {
        let wrapper = factory.makeOrderForPayment(delegate: self)
        self.viewControllerProgressWrapper = wrapper
        self.viewControllerProgressWrapper?.startProgress()
    }
    
    func showPaymentMethodsFlow() {
        guard let order = order else { return }
        let vc = factory.makePaymentMethods(delegate: self, order: order)
        self.paymentMethodsViewController = vc
        navigationController.pushViewController(vc, animated: false)
    }
    
    func show3DSecureFlow(url: URL, paymentId: String) {
        let vc = factory.make3DSecure(delegate: self, url: url, paymentId: paymentId)
        self.threeDSecureViewController = vc
        self.navigationController.pushViewController(vc, animated: false)
    }
    
    func showPaymentResultFlow() {
        let vc = factory.makePaymentResult(delegate: self)
        self.paymentResultViewController = vc
        self.navigationController.pushViewController(vc, animated: false)
    }
    
    func dismiss3DSecureFlow() {
        self.navigationController.viewControllers = self.navigationController.viewControllers.filter { $0 != threeDSecureViewController }
        
    }
    
    func dismissPaymentMethodsFlow() {
        self.navigationController.viewControllers = self.navigationController.viewControllers.filter { $0 != paymentMethodsViewController }
    }
    
    func dismissPaymentResultFlow() {
        self.navigationController.viewControllers = self.navigationController.viewControllers.filter { $0 != paymentResultViewController }
    }
    
}

extension PaymentCoordinator: PaymentMethodsNavigationDelegate, ThreeDSecureNavigationDelegate {
    func dismissPaymentResult() {
        dismissPaymentResultFlow()
    }
    
    func dismissPaymentMethodsViewController() {
        dismissPaymentMethodsFlow()
    }
    
    func dismissPaymentMethodsViewController(_ payment: Payment) {
        showPaymentResultFlow()
        paymentResultViewController?.configure(order: self.order)
        dismissPaymentMethodsFlow()
    }
    
    func dismissPaymentMethodsViewController(_ action: Action, payment: Payment) {
        show3DSecureFlow(url: action.url, paymentId: payment.id)
        dismissPaymentMethodsFlow()
    }
    
    func dismissPaymentMethodsViewController(_ error: Error) {
        showPaymentResultFlow()
        paymentResultViewController?.configure(error: error)
        dismissPaymentMethodsFlow()
    }
    
    func dismissPaymentMethodsViewController(_ apiError: APIError) {
        showPaymentResultFlow()
        paymentResultViewController?.configure(error: apiError)
        dismissPaymentMethodsFlow()
    }
    
    func dismissProgressWrapper(_ order: Order) {
        self.viewControllerProgressWrapper?.hideProgress()
        self.order = order
        showPaymentMethodsFlow()
    }
    
    func dismissProgressWrapper(_ error: Error) {
        self.viewControllerProgressWrapper?.hideProgress()
        self.viewControllerProgressWrapper?.showError(error: error)
    }
    
    func dismissThreeDSecure() {
        dismiss3DSecureFlow()
    }
    
    func dismissThreeDSecure(payment: Payment) {
        showPaymentResultFlow()
        paymentResultViewController?.configure(order: self.order)
        dismiss3DSecureFlow()
    }
    
    func dismissThreeDSecure(apiError: APIError) {
        self.dismiss3DSecureFlow()
        self.showPaymentResultFlow()
        self.paymentResultViewController?.configure(error: apiError)
    }
    
    func dismissThreeDSecure(error: Error) {
        self.dismiss3DSecureFlow()
        self.showPaymentResultFlow()
        self.paymentResultViewController?.configure(error: error)
    }
    
    func dismissThreeDSecure(savedCard: SavedCard) {
        dismiss3DSecureFlow()
    }
    
    
}
