//
//  ApplePayCoordinator.swift
//  Ioka
//
//  Created by ablai erzhanov on 24.05.2022.
//

import UIKit
import PassKit


internal class ApplePayResultCoordinator: NSObject, Coordinator {
    let factory: ApplePayResultFlowFactory
    let sourceViewController: UIViewController

    lazy var navigationController: UINavigationController = {
        let controller = IokaNavigationController()
        controller.modalPresentationStyle = .overFullScreen

        return controller
    }()

    var order: Order?

    var paymentResultViewController: PaymentResultViewController?
    var threeDSecureViewController: ThreeDSecureViewController?

    var resultCompletion: ((FlowResult) -> Void)?

    init(factory: ApplePayResultFlowFactory, sourceViewController: UIViewController) {
        self.factory = factory
        self.sourceViewController = sourceViewController
    }

    func start(applePayTokenResult: ApplePayTokenResult) {
        showApplePayResult(applePayTokenResult: applePayTokenResult)
    }

    private func showApplePayResult(applePayTokenResult: ApplePayTokenResult) {
        sourceViewController.present(navigationController, animated: true)
        setPaymentMethodsToNavigationController(applePayTokenResult: applePayTokenResult, animated: false)
    }

    private func setPaymentMethodsToNavigationController(applePayTokenResult: ApplePayTokenResult, animated: Bool) {

        switch applePayTokenResult {
        case .succeed:
            showPaymentResult(.success)
        case .failure(let error):
            dismissFlow(result: .failed(error))
        case .applePayDidFail(let declineError):
            showPaymentResult(.error(declineError))
        case .requiresAction(let action, let payment):
            showThreeDSecure(action: action, paymentId: payment.id)
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

    private func dismissFlow(result: FlowResult) {
        sourceViewController.dismiss(animated: true) {
            self.resultCompletion?(result)
        }
    }
}

extension ApplePayResultCoordinator: ThreeDSecureNavigationDelegate, PaymentResultNavigationDelegate {

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

    func paymentResultDidRetry(result: PaymentResult) {
        dismissFlow(result: .init(paymentResult: result))
    }
}
