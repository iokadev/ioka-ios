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
        let wrapper = factory.makeOrderForPayment(delegate: self, sourceViewController: sourceViewController)
        self.orderForPaymentProgressWrapper = wrapper
        self.orderForPaymentProgressWrapper?.startProgress()
    }
    
    private func showPaymentMethods() {
        setPaymentMethodsToNavigationController(animated: false)
        sourceViewController.present(navigationController, animated: true)
    }
    
    private func setPaymentMethodsToNavigationController(animated: Bool) {
        guard let order = order else { return }
        let vc = factory.makePaymentMethods(delegate: self, order: order)
        self.paymentMethodsViewController = vc
        
        if animated {
            let controllers = navigationController.viewControllers.last.map { [vc, $0] } ?? [vc]
            navigationController.setViewControllers(controllers, animated: false)
            navigationController.popToRootViewController(animated: true)
        } else {
            navigationController.setViewControllers([vc], animated: false)
        }
    }
    
    private func showThreeDSecure(action: Action, paymentId: String) {
        let vc = factory.makeThreeDSecure(delegate: self, action: action, paymentId: paymentId)
        self.threeDSecureViewController = vc
        self.navigationController.pushViewController(vc, animated: true)
    }
    
    private func showPaymentResult(_ result: PaymentResult) {
        guard let order = order else { return }

        let vc = factory.makePaymentResult(delegate: self, order: order, result: result)
        self.paymentResultViewController = vc
        self.navigationController.pushViewController(vc, animated: true)
    }

    private func handleResultScreen(_ result: PaymentResult) {
        switch factory.input.showResultScreen {
        case true:
            showPaymentResult(result)
        case false:
            dismissFlow(result: .init(paymentResult: result))
        }
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
        handleResultScreen(.success)
    }
    
    func paymentMethodsDidRequireThreeDSecure(action: Action, payment: Payment) {
        showThreeDSecure(action: action, paymentId: payment.id)
    }
    
    func paymentMethodsDidFail(declineError: Error) {
        handleResultScreen(.error(declineError))
    }
    
    func threeDSecureDidCancel() {
        dismissFlow(result: .cancelled)
    }
    
    func threeDSecureDidSucceed() {
        handleResultScreen(.success)
    }
    
    func threeDSecureDidFail(declinedError: Error) {
        handleResultScreen(.error(declinedError))
    }
    
    func threeDSecureDidFail(otherError: Error) {
        navigationController.popViewController(animated: true)
        paymentMethodsViewController?.show(error: otherError)
    }
    
    func paymentResultDidClose(result: PaymentResult) {
        dismissFlow(result: .init(paymentResult: result))
    }
    
    func paymentResultDidRetry(result: PaymentResult) {
        setPaymentMethodsToNavigationController(animated: true)
    }
}
