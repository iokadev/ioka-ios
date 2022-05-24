//
//  ApplePayCoordinator.swift
//  Ioka
//
//  Created by ablai erzhanov on 24.05.2022.
//

import UIKit
import PassKit


internal class ApplePayCoordinator: NSObject, Coordinator {
    let factory: ApplePayFlowFactory
    let sourceViewController: UIViewController

    lazy var navigationController: UINavigationController = {
        let controller = IokaNavigationController()
        controller.modalPresentationStyle = .overFullScreen

        return controller
    }()

    var order: Order?

    var applePayViewController: PKPaymentAuthorizationViewController?
    var paymentResultViewController: PaymentResultViewController?
    var threeDSecureViewController: ThreeDSecureViewController?

    var resultCompletion: ((FlowResult) -> Void)?

    init(factory: ApplePayFlowFactory, sourceViewController: UIViewController) {
        self.factory = factory
        self.sourceViewController = sourceViewController
    }

    func start() {
        showApplePay()
    }

    private func showApplePay() {
        sourceViewController.present(navigationController, animated: true)
        setPaymentMethodsToNavigationController(animated: false)
    }

    private func setPaymentMethodsToNavigationController(animated: Bool) {
        guard let vc = factory.makeApplePay(delegate: self).applePayVC else { return }
        self.applePayViewController = vc

        navigationController.present(vc, animated: animated)
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

    private func dismissFlow(result: FlowResult) {
        sourceViewController.dismiss(animated: true) {
            self.resultCompletion?(result)
        }
    }
}

extension ApplePayCoordinator: ApplePayNavigationDelegate, ThreeDSecureNavigationDelegate, PaymentResultNavigationDelegate {

    func applePayDidCancel() {
        dismissFlow(result: .cancelled)
    }

    func applePayDidSucceed() {
        showPaymentResult(.success)
    }

    func applePayRequiresAction(action: Action, payment: Payment) {
        showThreeDSecure(action: action, paymentId: payment.id)
    }

    func applePayDidFail(declineError: Error) {
        showPaymentResult(.error(declineError))
    }

    func applePayDismiss() {
        applePayViewController?.dismiss(animated: false)
    }

    func errorForResult(error: Error) {
        dismissFlow(result: .failed(error))
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
        navigationController.popViewController(animated: true)    }

    func paymentResultDidClose(result: PaymentResult) {
        dismissFlow(result: .init(paymentResult: result))
    }

    func paymentResultDidRetry() {
        setPaymentMethodsToNavigationController(animated: true)
    }
}
