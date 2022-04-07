//
//  ErrorPopUpViewModel.swift
//  IOKA
//
//  Created by ablai erzhanov on 04.04.2022.
//

import Foundation


class ErrorPopUpViewModel {
    
    weak var paymentWithSavedCardDelegate: PaymentWithSavedCardNavigationDelegate?
    
    init(delegate: PaymentWithSavedCardNavigationDelegate) {
        self.paymentWithSavedCardDelegate = delegate
    }
    
    func dismiss() {
        self.paymentWithSavedCardDelegate?.dismissErrorPopup()
    }
}
