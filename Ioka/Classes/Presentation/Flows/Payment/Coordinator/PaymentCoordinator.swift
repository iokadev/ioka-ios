//
//  PaymentCoordinator.swift
//  Ioka
//
//  Created by ablai erzhanov on 05.04.2022.
//

import UIKit


internal class PaymentCoordinator: NSObject, Coordinator {
    let factory: PaymentFlowFactory
    var navigationController: UINavigationController
    private var order: Order?
    
    var paymentMethodsViewController: PaymentMethodsViewController?
    var paymentResultViewController: PaymentResultViewController?
    var viewControllerProgressWrapper: ViewControllerProgressWrapper?
    var threeDSecureViewController: ThreeDSecureViewController?
    
    var resultCompletion: ((FlowResult) -> Void)?
    
    init(factory: PaymentFlowFactory, navigationController: UINavigationController) {
        self.factory = factory
        self.navigationController = navigationController
    }
    
    func start() {
        showViewControllerProgressWrapperFlow()
    }
    
    func showViewControllerProgressWrapperFlow() {
        let wrapper = factory.makeOrderForPayment(delegate: self)
        self.viewControllerProgressWrapper = wrapper
        self.viewControllerProgressWrapper?.startProgress()
    }
    
    func showPaymentMethodsFlow() {
        guard let order = order else { return }
        let vc = factory.makePaymentMethods(delegate: self, order: order)
        vc.modalPresentationStyle = .overFullScreen
        self.paymentMethodsViewController = vc
        navigationController.present(vc, animated: false)
    }
    
    func show3DSecureFlow(url: URL, paymentId: String) {
        let vc = factory.make3DSecure(delegate: self, url: url, paymentId: paymentId)
        vc.modalPresentationStyle = .overFullScreen
        self.threeDSecureViewController = vc
        self.navigationController.present(vc, animated: false)
    }
    
    func showPaymentResultFlow() {
        let vc = factory.makePaymentResult(delegate: self)
        vc.modalPresentationStyle = .overFullScreen
        self.paymentResultViewController = vc
        self.navigationController.present(vc, animated: false)
    }
    
    func dismiss3DSecureFlow() {
        self.navigationController.dismiss(animated: false)
        
    }
    
    func dismissPaymentMethodsFlow() {
        self.navigationController.dismiss(animated: false)
    }
    
    func dismissPaymentResultFlow() {
        self.navigationController.dismiss(animated: false)
    }
    
}

extension PaymentCoordinator: PaymentMethodsNavigationDelegate, ThreeDSecureNavigationDelegate {
    func dismissPaymentResult() {
        dismissPaymentResultFlow()
        resultCompletion?(.succeeded)
    }
    
    func dismissPaymentMethodsViewController() {
        dismissPaymentMethodsFlow()
        resultCompletion?(.cancelled)
    }
    
    func dismissPaymentMethodsViewController(_ payment: Payment) {
        dismissPaymentMethodsFlow()
        showPaymentResultFlow()
        paymentResultViewController?.configure(order: self.order)
    }
    
    func dismissPaymentMethodsViewController(_ action: Action, payment: Payment) {
        dismissPaymentMethodsFlow()
        show3DSecureFlow(url: action.url, paymentId: payment.id)
    }
    
    func dismissPaymentMethodsViewController(_ error: Error) {
        dismissPaymentMethodsFlow()
        showPaymentResultFlow()
        paymentResultViewController?.configure(error: error)
        resultCompletion?(.failed(error))
    }
    
    func dismissPaymentMethodsViewController(_ apiError: APIError) {
        dismissPaymentMethodsFlow()
        showPaymentResultFlow()
        paymentResultViewController?.configure(error: apiError)
        resultCompletion?(.failed(apiError))
    }
    
    func dismissProgressWrapper(_ order: Order) {
        self.viewControllerProgressWrapper?.hideProgress()
        self.order = order
        showPaymentMethodsFlow()
    }
    
    func dismissProgressWrapper(_ error: Error) {
        self.viewControllerProgressWrapper?.hideProgress()
        self.viewControllerProgressWrapper?.showError(error: error) { [weak self] in
            self?.resultCompletion?(.failed(error))
        }
    }
    
    func dismissThreeDSecure() {
        dismiss3DSecureFlow()
        resultCompletion?(.cancelled)
    }
    
    func dismissThreeDSecure(payment: Payment) {
        dismiss3DSecureFlow()
        showPaymentResultFlow()
        paymentResultViewController?.configure(order: self.order)
    }
    
    func dismissThreeDSecure(apiError: APIError) {
        self.dismiss3DSecureFlow()
        self.showPaymentResultFlow()
        self.paymentResultViewController?.configure(error: apiError)
        resultCompletion?(.failed(apiError))
    }
    
    func dismissThreeDSecure(error: Error) {
        self.showPaymentResultFlow()
        self.paymentResultViewController?.configure(error: error)
        self.dismiss3DSecureFlow()
        resultCompletion?(.failed(error))
    }
    
    func dismissThreeDSecure(savedCard: SavedCard) {
        dismiss3DSecureFlow()
    }
    
    
}
