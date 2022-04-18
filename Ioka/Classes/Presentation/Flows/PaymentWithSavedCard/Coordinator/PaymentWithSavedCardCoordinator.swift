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
    var errorPopupViewController: ErrorPopUpViewController?
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
    
    func showCVVFlow() {
        let vc = factory.makeCVVSavedCardPayment(delegate: self)
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        self.cvvViewController = vc
        sourceViewController.present(vc, animated: false)
    }
    
    func show3DSecureFlow(url: URL, paymentId: String) {
        let vc = factory.make3DSecure(delegate: self, url: url, paymentId: paymentId)
        self.threeDSecureViewController = vc
        
        paymentProgressWrapper?.hideProgress()
        sourceViewController.dismiss(animated: true) {
            self.navigationController.setViewControllers([vc], animated: false)
            self.sourceViewController.present(self.navigationController, animated: true)
        }
    }
    
    func showResultFlow(hasError: Bool) {
        hasError ? showErrorPopupFlow() : showPaymentResultFlow()
    }
    
    func showPaymentResultFlow() {
        let vc = factory.makePaymentResult(delegate: self)
        self.paymentResultViewController = vc
        
        if navigationController.viewControllers.count > 0 {
            navigationController.pushViewController(vc, animated: true)
        } else {
            navigationController.setViewControllers([vc], animated: false)
            sourceViewController.present(navigationController, animated: true)
        }
    }
    
    func showErrorPopupFlow() {
        let vc = factory.makePaymentResultPopup(delegate: self)
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        self.errorPopupViewController = vc
        
        sourceViewController.dismiss(animated: true) {
            self.sourceViewController.present(vc, animated: false)
        }
    }
    
    func dismissFlow() {
        self.sourceViewController.dismiss(animated: true)
    }
}


extension PaymentWithSavedCardCoordinator: PaymentWithSavedCardNavigationDelegate, ThreeDSecureNavigationDelegate {
    
    func showPaymentResult(apiError: APIError) {
        self.showResultFlow(hasError: true)
        self.errorPopupViewController?.showError(apiError)
    }
    
    func showPaymentResult(error: Error) {
        showResultFlow(hasError: true)
        self.errorPopupViewController?.showError(error)
        resultCompletion?(.failed(error))
    }
    
    func showPaymentResult() {
        showResultFlow(hasError: false)
        self.paymentResultViewController?.configure(order: self.order)
    }
    
    func dismissCVVForm(error: Error) {
        self.dismissFlow()
        resultCompletion?(.failed(error))
    }
    
    func showCVVForm() {
        self.showCVVFlow()
    }
    
    func showThreeDSecure(_ action: Action, payment: Payment) {
        self.show3DSecureFlow(url: action.url, paymentId: payment.id)
    }
    
    func dismissProgressWrapper(_ error: Error) {
        self.paymentProgressWrapper?.hideProgress()
        self.paymentProgressWrapper?.showError(error: error) { [weak self] in
            self?.resultCompletion?(.failed(error))
        }
    }
    
    func dismissProgressWrapper(_ order: Order, isCVVRequired: Bool, apiError: APIError?) {
        self.paymentProgressWrapper?.hideProgress()
        
        self.order = order
        if isCVVRequired {
            self.showCVVFlow()
        } else {
            if let apiError = apiError {
                showResultFlow(hasError: true)
                self.errorPopupViewController?.showError(apiError)
                resultCompletion?(.failed(apiError))
            } else {
                showResultFlow(hasError: false)
                self.paymentResultViewController?.configure(order: self.order)
            }
        }
    }
    
    func dismissCVVForm() {
        self.dismissFlow()
        resultCompletion?(.cancelled)
    }
    
    func dismissPaymentResult() {
        self.dismissFlow()
        resultCompletion?(.succeeded)
    }
    
    func dismissThreeDSecure() {
        self.dismissFlow()
        resultCompletion?(.cancelled)
    }
    
    func dismissErrorPopup() {
        self.dismissFlow()
        // TODO: .failed
        resultCompletion?(.cancelled)
    }
    
    func dismissThreeDSecure(payment: Payment) {
        self.showResultFlow(hasError: false)
        // TODO: нет order, надо переделать NavigationDelegate
        self.paymentResultViewController?.configure(order: self.order)
    }
    
    func dismissThreeDSecure(apiError: APIError) {
        self.showResultFlow(hasError: true)
        self.errorPopupViewController?.showError(apiError)
        resultCompletion?(.failed(apiError))
    }
    
    func dismissThreeDSecure(error: Error) {
        self.showResultFlow(hasError: true)
        self.errorPopupViewController?.showError(error)
        resultCompletion?(.failed(error))
    }
    
    func dismissThreeDSecure(cardSaving: CardSaving) {}
}



