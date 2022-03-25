//
//  PaymentWithSavedCardViewModel.swift
//  IOKA
//
//  Created by ablai erzhanov on 24.03.2022.
//

import Foundation


class SavedCardPaymentViewModel {
    
    func createCardPayment(orderId: String, card: Card, completion: @escaping(OrderStatus, IokaError?, CardPaymentResponse?) -> Void) {
        
        let queue = DispatchQueue.global(qos: .userInitiated)
        queue.async {
            DispatchQueue.main.async {
                IokaApi.shared.createCardPayment(orderId: orderId, card: card) { [weak self] result, error in
                    guard let _ = self else { return }
                    guard error == nil else { completion(.paymentFailed, error, nil)
                        return
                    }
                    guard let result = result else { return }
                    
                    guard result.error == nil else { completion(.paymentFailed, nil, result)
                        return
                    }
                    
                    completion(.paymentSucceed, nil, result)
                }
            }
        }
    }
}
