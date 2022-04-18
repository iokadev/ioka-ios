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
        let controller = IokaNavigationController()
        controller.modalPresentationStyle = .overFullScreen
        
        return controller
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
    
    private func show3DSecure(action: Action, paymentId: String) {
        let vc = factory.make3DSecure(delegate: self, action: action, paymentId: paymentId)
        self.threeDSecureViewController = vc
        self.navigationController.pushViewController(vc, animated: false)
    }
    
    private func showPaymentResult(_ result: PaymentResult) {
        guard let order = order else { return }

        let vc = factory.makePaymentResult(delegate: self, order: order, result: result)
        self.paymentResultViewController = vc
        self.navigationController.pushViewController(vc, animated: false)
    }
    
    private func dismissFlow(result: FlowResult) {
        sourceViewController.dismiss(animated: true) {
            self.resultCompletion?(result)
        }
    }
}

extension PaymentCoordinator: OrderForPaymentNavigationDelegate, PaymentMethodsNavigationDelegate, ThreeDSecureNavigationDelegate, PaymentResultNavigationDelegate {
    func orderForPaymentDidReceiveOrder(order: Order) {
        orderForPaymentProgressWrapper?.hideProgress()
        self.order = order
        showPaymentMethods()
    }
    
    func orderForPaymentDidFail(error: Error) {
        orderForPaymentProgressWrapper?.hideProgress()
        orderForPaymentProgressWrapper?.showError(error: error) { [weak self] in
            self?.resultCompletion?(.failed(error))
        }
    }
    
    func paymentMethodsDidCancel() {
        dismissFlow(result: .cancelled)
    }
    
    func paymentMethodsDidSucceed() {
        showPaymentResult(.success)
    }
    
    func paymentMethodsDidRequire3DSecure(action: Action, payment: Payment) {
        show3DSecure(action: action, paymentId: payment.id)
    }
    
    func paymentMethodsDidFail(declineError: Error) {
        showPaymentResult(.error(declineError))
    }
    
    func threeDSecureDidCancel() {
        dismissFlow(result: .cancelled)
    }
    
    func threeDSecureDidSucceed() {
        showPaymentResult(.success)
    }
    
    func threeDSecureDidFail(declinedError: Error) {
        showPaymentResult(.error(declinedError))
    }
    
    func threeDSecureDidFail(otherError: Error) {
        navigationController.popViewController(animated: true)
        paymentMethodsViewController?.showError(otherError)
    }
    
    func paymentResultDidClose(result: PaymentResult) {
        dismissFlow(result: .init(paymentResult: result))
    }
    
    func paymentResultDidRetry() {
        setPaymentMethodsToNavigationController()
    }
}
