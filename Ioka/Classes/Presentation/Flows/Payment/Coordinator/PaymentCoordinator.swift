//
//  PaymentCoordinator.swift
//  Ioka
//
//  Created by ablai erzhanov on 05.04.2022.
//

import UIKit


internal class PaymentCoordinator: NSObject, Coordinator {
    let factory: PaymentFlowFactory
    let sourceViewController: UIViewController
    
    lazy var navigationController: UINavigationController = {
        let vc = UINavigationController()
        vc.modalPresentationStyle = .overFullScreen
        
        return vc
    }()
    
    private var order: Order?
    
    var paymentMethodsViewController: PaymentMethodsViewController?
    var paymentResultViewController: PaymentResultViewController?
    var orderForPaymentProgressWrapper: ViewControllerProgressWrapper?
    var threeDSecureViewController: ThreeDSecureViewController?
    
    var resultCompletion: ((FlowResult) -> Void)?
    
    init(factory: PaymentFlowFactory, sourceViewController: UIViewController) {
        self.factory = factory
        self.sourceViewController = sourceViewController
    }
    
    func start() {
        showOrderForPayment()
    }
    
    private func showOrderForPayment() {
        let wrapper = factory.makeOrderForPayment(delegate: self)
        self.orderForPaymentProgressWrapper = wrapper
        self.orderForPaymentProgressWrapper?.startProgress()
    }
    
    private func showPaymentMethods() {
        setPaymentMethodsToNavigationController()
        sourceViewController.present(navigationController, animated: true)
    }
    
    private func setPaymentMethodsToNavigationController() {
        guard let order = order else { return }
        let vc = factory.makePaymentMethods(delegate: self, order: order)
        self.paymentMethodsViewController = vc
        
        navigationController.setViewControllers([vc], animated: false)
    }
    
    private func show3DSecure(url: URL, paymentId: String) {
        let vc = factory.make3DSecure(delegate: self, url: url, paymentId: paymentId)
        self.threeDSecureViewController = vc
        self.navigationController.pushViewController(vc, animated: false)
    }
    
    private func showPaymentResult() {
        let vc = factory.makePaymentResult(delegate: self)
        self.paymentResultViewController = vc
        self.navigationController.pushViewController(vc, animated: false)
    }
    
    private func dismissFlow() {
        sourceViewController.dismiss(animated: false)
    }
}

extension PaymentCoordinator: PaymentMethodsNavigationDelegate, ThreeDSecureNavigationDelegate {
    func dismissPaymentResult(retry: Bool) {
        if retry {
            setPaymentMethodsToNavigationController()
        } else {
            dismissFlow()
            resultCompletion?(.succeeded)
        }
    }
    
    func dismissPaymentMethodsViewController() {
        dismissFlow()
        resultCompletion?(.cancelled)
    }
    
    func dismissPaymentMethodsViewController(_ payment: Payment) {
        showPaymentResult()
        paymentResultViewController?.configure(order: self.order)
    }
    
    func dismissPaymentMethodsViewController(_ action: Action, payment: Payment) {
        show3DSecure(url: action.url, paymentId: payment.id)
    }
    
    func dismissPaymentMethodsViewController(_ error: Error) {
        showPaymentResult()
        paymentResultViewController?.configure(error: error)
        resultCompletion?(.failed(error))
    }
    
    func dismissPaymentMethodsViewController(_ apiError: APIError) {
        showPaymentResult()
        paymentResultViewController?.configure(error: apiError)
        resultCompletion?(.failed(apiError))
    }
    
    func dismissProgressWrapper(_ order: Order) {
        self.orderForPaymentProgressWrapper?.hideProgress()
        self.order = order
        showPaymentMethods()
    }
    
    func dismissProgressWrapper(_ error: Error) {
        self.orderForPaymentProgressWrapper?.hideProgress()
        self.orderForPaymentProgressWrapper?.showError(error: error) { [weak self] in
            self?.resultCompletion?(.failed(error))
        }
    }
    
    func dismissThreeDSecure() {
        dismissFlow()
        resultCompletion?(.cancelled)
    }
    
    func dismissThreeDSecure(payment: Payment) {
        showPaymentResult()
        paymentResultViewController?.configure(order: self.order)
    }
    
    func dismissThreeDSecure(apiError: APIError) {
        self.showPaymentResult()
        self.paymentResultViewController?.configure(error: apiError)
        resultCompletion?(.failed(apiError))
    }
    
    func dismissThreeDSecure(error: Error) {
        self.showPaymentResult()
        self.paymentResultViewController?.configure(error: error)
        resultCompletion?(.failed(error))
    }
    
    func dismissThreeDSecure(cardSaving: CardSaving) {
        navigationController.popViewController(animated: true)
    }
}
