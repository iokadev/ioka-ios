//
//  PaymentWithSavedCardCoordinator.swift
//  Ioka
//
//  Created by ablai erzhanov on 05.04.2022.
//

import UIKit


internal class PaymentWithSavedCardCoordinator: NSObject, Coordinator {

    let factory: PaymentWithSavedCardFlowFactory
    let sourceViewController: UIViewController
    
    lazy var navigationController: UINavigationController = {
        let controller = IokaNavigationController()
        controller.modalPresentationStyle = .overFullScreen
        
        return controller
    }()
    
    private var order: Order?
    
    var paymentProgressWrapper: ViewControllerProgressWrapper?
    var cvvViewController: CVVViewController?
    var paymentResultViewController: PaymentResultViewController?
    var errorPopupViewController: ErrorPopupViewController?
    var threeDSecureViewController: ThreeDSecureViewController?
    
    var resultCompletion: ((FlowResult) -> Void)?
    
    init(factory: PaymentWithSavedCardFlowFactory, sourceViewController: UIViewController) {
        self.factory = factory
        self.sourceViewController = sourceViewController
    }
    
    func start() {
        showPaymentProgressWrapper()
    }
    
    func showPaymentProgressWrapper() {
        let wrapper = factory.makeSavedCardPayment(delegate: self)
        self.paymentProgressWrapper = wrapper
        self.paymentProgressWrapper?.startProgress()
    }
    
    func showCVV() {
        let vc = factory.makeCVVSavedCardPayment(delegate: self)
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        self.cvvViewController = vc
        sourceViewController.present(vc, animated: false)
    }
    
    func show3DSecure(action: Action, paymentId: String) {
        let vc = factory.make3DSecure(delegate: self, action: action, paymentId: paymentId)
        self.threeDSecureViewController = vc
        
        sourceViewController.dismiss(animated: true) {
            self.navigationController.setViewControllers([vc], animated: false)
            self.sourceViewController.present(self.navigationController, animated: true)
        }
    }
    
    func showSuccessPaymentResult() {
        guard let order = order else {
            return
        }
        
        let vc = factory.makePaymentResult(delegate: self, order: order, result: .success)
        self.paymentResultViewController = vc
        
        if navigationController.viewControllers.count > 0 {
            navigationController.pushViewController(vc, animated: true)
        } else {
            navigationController.setViewControllers([vc], animated: false)
            sourceViewController.present(navigationController, animated: true)
        }
    }
    
    func showErrorPopup(error: Error) {
        let vc = factory.makePaymentResultPopup(delegate: self, error: error)
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        self.errorPopupViewController = vc
        
        sourceViewController.dismiss(animated: true) {
            self.sourceViewController.present(vc, animated: false)
        }
    }
    
    func dismissFlow(result: FlowResult) {
        sourceViewController.dismiss(animated: true) {
            self.resultCompletion?(result)
        }
    }
    
    func dismissWithErrorInProgressWrapper(_ error: Error) {
        sourceViewController.dismiss(animated: true) {
            self.paymentProgressWrapper?.showError(error: error) { [weak self] in
                self?.resultCompletion?(.failed(error))
            }
        }
    }
}


extension PaymentWithSavedCardCoordinator: PaymentWithSavedCardNavigationDelegate, CVVNavigationDelegate,
                                            ThreeDSecureNavigationDelegate, PaymentResultNavigationDelegate,
                                            ErrorPopupNavigationDelegate {
    func paymentWithSavedCardDidReceiveOrder(_ order: Order) {
        self.order = order
    }
    
    func paymentWithSavedCardDidRequireCVV() {
        paymentProgressWrapper?.hideProgress()
        showCVV()
    }
    
    func paymentWithSavedCardDidRequireThreeDSecure(action: Action, payment: Payment) {
        paymentProgressWrapper?.hideProgress()
        show3DSecure(action: action, paymentId: payment.id)
    }
    
    func paymentWithSavedCardDidSucceed() {
        paymentProgressWrapper?.hideProgress()
        showSuccessPaymentResult()
    }
    
    func paymentWithSavedCardDidFail(declineError: Error) {
        paymentProgressWrapper?.hideProgress()
        showErrorPopup(error: declineError)
    }
    
    func paymentWithSavedCardDidFail(otherError: Error) {
        paymentProgressWrapper?.hideProgress()
        dismissWithErrorInProgressWrapper(otherError)
    }
    
    func cvvDidRequireThreeDSecure(action: Action, payment: Payment) {
        show3DSecure(action: action, paymentId: payment.id)
    }
    
    func cvvDidSucceed() {
        showSuccessPaymentResult()
    }
    
    func cvvDidFail(declineError: Error) {
        showErrorPopup(error: declineError)
    }
    
    func cvvDidFail(otherError: Error) {
        dismissWithErrorInProgressWrapper(otherError)
    }
    
    func cvvDidCancel() {
        dismissFlow(result: .cancelled)
    }
    
    func threeDSecureDidSucceed() {
        showSuccessPaymentResult()
    }
    
    func threeDSecureDidFail(declinedError: Error) {
        showErrorPopup(error: declinedError)
    }
    
    func threeDSecureDidFail(otherError: Error) {
        dismissWithErrorInProgressWrapper(otherError)
    }
    
    func threeDSecureDidCancel() {
        dismissFlow(result: .cancelled)
    }
    
    func paymentResultDidClose(result: PaymentResult) {
        dismissFlow(result: .init(paymentResult: result))
    }
    
    func paymentResultDidRetry() {
        // не вызывается в этом флоу, так как PaymentResult показывается только в случае успешной оплаты
    }
    
    func errorPopupDidClose(error: Error) {
        dismissFlow(result: .failed(error))
    }
}



