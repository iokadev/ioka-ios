//
//  PaymentResultViewModel.swift
//  IOKA
//
//  Created by ablai erzhanov on 03.04.2022.
//

import Foundation


class PaymentResultViewModel {
    
    weak var paymentWithSavedCardDelegate: PaymentWithSavedCardNavigationDelegate?
    weak var paymentMethodsDelegate: PaymentMethodsNavigationDelegate?
    
    init(delegate: PaymentWithSavedCardNavigationDelegate) {
        self.paymentWithSavedCardDelegate = delegate
    }
    
    init(delegate: PaymentMethodsNavigationDelegate) {
        self.paymentMethodsDelegate = delegate
    }
    
    
    func closePaymentResultViewController() {
        paymentWithSavedCardDelegate?.dismissPaymentResult()
        paymentMethodsDelegate?.dismissPaymentResult()
    }
    
    func retryPaymentProcess() {
        paymentWithSavedCardDelegate?.dismissPaymentResult()
        paymentMethodsDelegate?.dismissPaymentResult()
    }
}
