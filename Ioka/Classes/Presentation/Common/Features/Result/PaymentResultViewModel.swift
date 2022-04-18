//
//  PaymentResultViewModel.swift
//  IOKA
//
//  Created by ablai erzhanov on 03.04.2022.
//

import Foundation

protocol PaymentResultNavigationDelegate: AnyObject {
    func paymentResultDidClose(result: PaymentResult)
    func paymentResultDidRetry()
}

enum PaymentResult {
    case success
    case error(Error)
}

internal class PaymentResultViewModel {
    let order: Order
    let result: PaymentResult
    weak var delegate: PaymentResultNavigationDelegate?
    
    init(order: Order, result: PaymentResult, delegate: PaymentResultNavigationDelegate) {
        self.order = order
        self.result = result
        self.delegate = delegate
    }
    
    func close() {
        delegate?.paymentResultDidClose(result: result)
    }
    
    func retry() {
        delegate?.paymentResultDidRetry()
    }
}
