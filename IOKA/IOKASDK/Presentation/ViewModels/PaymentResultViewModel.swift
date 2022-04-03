//
//  PaymentResultViewModel.swift
//  IOKA
//
//  Created by ablai erzhanov on 03.04.2022.
//

import Foundation


class PaymentResultViewModel {
    
    weak var delegate: PaymentResultNavigationDelegate?
    
    
    func closePaymentResultViewController() {
        delegate?.closePaymentResultViewController()
    }
    
    func retryPaymentProcess() {
        delegate?.retryPaymentProcess()
    }
}
