//
//  PaymentWithSavedCardCoordinator.swift
//  Ioka
//
//  Created by ablai erzhanov on 05.04.2022.
//

import UIKit


internal class PaymentWithSavedCardCoordinator: NSObject, Coordinator {

    let factory: PaymentWithSavedCardFlowFactory
    var navigationController: UINavigationController
    private var order: Order?
    
    var cvvViewControlelr: CVVViewController?
    var paymentResultViewController: PaymentResultViewController?
    var viewControllerProgressWrapper: ViewControllerProgressWrapper?
    var errorPopupViewController: ErrorPopUpViewController?
    var threeDSecureViewController: ThreeDSecureViewController?
    
    var resultCompletion: ((FlowResult) -> Void)?
    
    init(factory: PaymentWithSavedCardFlowFactory, navigationController: UINavigationController) {
        self.factory = factory
        self.navigationController = navigationController
    }
    
    func start() {
        showProgressWrapper()
    }
    
    func showViewControllerProgressWrapperFlow() {
        let wrapper = factory.makeOrderForPayment(delegate: self)
        self.viewControllerProgressWrapper = wrapper
        self.viewControllerProgressWrapper?.startProgress()
    }
    
    func showCVVFlow() {
        let vc = factory.makeSavedCardPayment(delegate: self)
        self.cvvViewControlelr = vc
        navigationController.present(vc, animated: false)
    }
    
    func show3DSecureFlow(url: URL, paymentId: String) {
        let vc = factory.make3DSecure(delegate: self, url: url, paymentId: paymentId)
        vc.modalPresentationStyle = .overFullScreen
        self.threeDSecureViewController = vc
        self.navigationController.present(vc, animated: false)
    }
    
    func showResultFlow(hasError: Bool) {
        hasError ? showErrorPopupFlow() : showPaymentResultFlow()
    }
    
    func showPaymentResultFlow() {
        let vc = factory.makePaymentResult(delegate: self)
        vc.modalPresentationStyle = .overFullScreen
        self.paymentResultViewController = vc
        self.navigationController.present(vc, animated: false)
    }
    
    func showErrorPopupFlow() {
        let vc = factory.makePaymentResultPopup(delegate: self)
        self.errorPopupViewController = vc
        self.navigationController.present(vc, animated: false)
    }
    
    func dismiss3DSecureFlow() {
        self.navigationController.dismiss(animated: false)
    }
    
    func dismissCVVFlow() {
        self.navigationController.dismiss(animated: false)
    }
    
    func dismissPaymentResultFlow() {
        self.navigationController.dismiss(animated: false)
    }
    
    func dismissErorPopupFlow() {
        self.navigationController.dismiss(animated: false)
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
        self.dismissCVVFlow()
        resultCompletion?(.failed(error))
    }
        
    func showProgressWrapper() {
        showViewControllerProgressWrapperFlow()
    }
    
    func showCVVForm() {
        self.showCVVFlow()
    }
    
    func showThreeDSecure(_ action: Action, payment: Payment) {
        self.show3DSecureFlow(url: action.url, paymentId: payment.id)
    }
    
    func dismissProgressWrapper(_ error: Error) {
        self.viewControllerProgressWrapper?.hideProgress()
        self.viewControllerProgressWrapper?.showError(error: error) { [weak self] in
            self?.resultCompletion?(.failed(error))
        }
    }
    
    func dismissProgressWrapper(_ order: Order, isCVVRequired: Bool, apiError: APIError?) {
        self.viewControllerProgressWrapper?.hideProgress()
        
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
        self.dismissCVVFlow()
        resultCompletion?(.cancelled)
    }
    
    func dismissPaymentResult() {
        self.dismissPaymentResultFlow()
        resultCompletion?(.succeeded)
    }
    
    func dismissThreeDSecure() {
        self.dismiss3DSecureFlow()
        resultCompletion?(.cancelled)
    }
    
    func dismissErrorPopup() {
        self.dismissErorPopupFlow()
        resultCompletion?(.cancelled)
    }
    
    func dismissThreeDSecure(payment: Payment) {
        self.dismiss3DSecureFlow()
        self.showResultFlow(hasError: false)
        self.paymentResultViewController?.configure(order: self.order)
    }
    
    func dismissThreeDSecure(apiError: APIError) {
        self.dismiss3DSecureFlow()
        self.showResultFlow(hasError: true)
        self.errorPopupViewController?.showError(apiError)
        resultCompletion?(.failed(apiError))
    }
    
    func dismissThreeDSecure(error: Error) {
        self.dismiss3DSecureFlow()
        self.showResultFlow(hasError: true)
        self.errorPopupViewController?.showError(error)
        resultCompletion?(.failed(error))
    }
    
    func dismissThreeDSecure(savedCard: SavedCard) {
        self.dismiss3DSecureFlow()
    }
}



