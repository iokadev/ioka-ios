//
//  SavedCardPaymentViewModel.swift
//  IOKA
//
//  Created by ablai erzhanov on 25.03.2022.
//

import Foundation


class SavedCardPaymentViewModel {
    
    var delegate: SavedCardPaymentNavigationDelegate?
    
    func completeSavedCardPaymentFlow(status: PaymentResult, error: IokaError?, response: CardPaymentResponse?) {
        DispatchQueue.main.async {
            self.delegate?.completeSavedCardPaymentFlow(status: status, error: error, response: response)
        }
    }
    
    func dismiss() {
        delegate?.dismissView()
    }
    
    func createCardPayment(orderId: String, card: Card) {
        
        let queue = DispatchQueue.global(qos: .userInitiated)
        queue.async {
            DispatchQueue.main.async {
                IokaApi.shared.createCardPayment(orderId: orderId, card: card) { [weak self] result in
                    guard let self = self else { return }
                    
                    switch result {
                    case .success(let cardPaymentResponse):
                        if let error = cardPaymentResponse.error {
                            self.completeSavedCardPaymentFlow(status: .paymentFailed, error: error, response: cardPaymentResponse)
                        } else {
                            self.completeSavedCardPaymentFlow(status: .paymentSucceed, error: nil, response: cardPaymentResponse)
                        }
                    case .failure(let error):
                        self.completeSavedCardPaymentFlow(status: .paymentFailed, error: error, response: nil)
                    }
                }
            }
        }
    }
}
