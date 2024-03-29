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
        let wrapper = factory.makeSavedCardPayment(delegate: self, sourceViewController: sourceViewController)
        self.paymentProgressWrapper = wrapper
        self.paymentProgressWrapper?.startProgress()
    }
    
    func showCVV() {
        let vc = factory.makeCVVSavedCardPayment(delegate: self)
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        self.cvvViewController = vc
        presentModally(vc)
    }
    
    func showThreeDSecure(action: Action, paymentId: String) {
        let vc = factory.makeThreeDSecure(delegate: self, action: action, paymentId: paymentId)
        self.threeDSecureViewController = vc
        
        showInNavigationController(vc)
    }
    
    func showSuccessPaymentResult() {
        guard let order = order else {
            return
        }
        
        let vc = factory.makePaymentResult(delegate: self, order: order, result: .success)
        self.paymentResultViewController = vc
        
        showInNavigationController(vc)
    }
    
    func showErrorPopup(error: Error) {
        let vc = factory.makePaymentResultPopup(delegate: self, error: error)
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        self.errorPopupViewController = vc
        
        presentModally(vc)
    }

    private func handleResultScreenState(result: PaymentResult) {
        switch factory.input.showResultScreen {
        case true:
            switch result {
            case .success:
                showSuccessPaymentResult()
            case .error(let error):
                showErrorPopup(error: error)
            }
        case false:
            dismissFlow(result: .init(paymentResult: result))
        }
    }
    
    func dismissFlow(result: FlowResult) {
        sourceViewController.dismiss(animated: navigationControllerIsPresented()) {
            self.resultCompletion?(result)
        }
    }
    
    func dismissWithErrorInProgressWrapper(_ error: Error) {
        sourceViewController.dismiss(animated: navigationControllerIsPresented()) {
            self.paymentProgressWrapper?.showError(error: error) { [weak self] in
                self?.resultCompletion?(.failed(error))
            }
        }
    }
    
    private func presentModally(_ controller: UIViewController) {
        sourceViewController.dismiss(animated: navigationControllerIsPresented()) {
            self.sourceViewController.present(controller, animated: true)
        }
    }
    
    private func showInNavigationController(_ controller: UIViewController) {
        if navigationControllerIsPresented() {
            navigationController.pushViewController(controller, animated: true)
        } else {
            navigationController.setViewControllers([controller], animated: false)
            sourceViewController.dismiss(animated: false)
            sourceViewController.present(navigationController, animated: true)
        }
    }
    
    private func navigationControllerIsPresented() -> Bool {
        navigationController.presentingViewController != nil
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
        showThreeDSecure(action: action, paymentId: payment.id)
    }
    
    func paymentWithSavedCardDidSucceed() {
        paymentProgressWrapper?.hideProgress()
        handleResultScreenState(result: .success)
    }
    
    func paymentWithSavedCardDidFail(declineError: Error) {
        paymentProgressWrapper?.hideProgress()
        handleResultScreenState(result: .error(declineError))
    }
    
    func paymentWithSavedCardDidFail(otherError: Error) {
        paymentProgressWrapper?.hideProgress()
        dismissWithErrorInProgressWrapper(otherError)
    }
    
    func cvvDidRequireThreeDSecure(action: Action, payment: Payment) {
        showThreeDSecure(action: action, paymentId: payment.id)
    }
    
    func cvvDidSucceed() {
        handleResultScreenState(result: .success)
    }
    
    func cvvDidFail(declineError: Error) {
        handleResultScreenState(result: .error(declineError))
    }
    
    func cvvDidFail(otherError: Error) {
        dismissWithErrorInProgressWrapper(otherError)
    }
    
    func cvvDidCancel() {
        dismissFlow(result: .cancelled)
    }
    
    func threeDSecureDidSucceed() {
        handleResultScreenState(result: .success)
    }
    
    func threeDSecureDidFail(declinedError: Error) {
        handleResultScreenState(result: .error(declinedError))
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
    
    func paymentResultDidRetry(result: PaymentResult) {
        // не вызывается в этом флоу, так как PaymentResult показывается только в случае успешной оплаты
    }
    
    func errorPopupDidClose(error: Error) {
        dismissFlow(result: .failed(error))
    }
}



