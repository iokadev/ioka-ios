//
//  PaymentTypeViewModel.swift
//  IOKA
//
//  Created by ablai erzhanov on 25.03.2022.
//

import Foundation

class PaymentTypeViewModel {
    func getCards(customerAccessToken: String, completion: @escaping([GetCardResponse]?, IokaError?) -> Void) {
        
        let queue = DispatchQueue.global(qos: .userInitiated)
        queue.async {
            IOKA.shared.getCards(customerAccessToken: customerAccessToken) { result, error in
                if let result = result {
                    DispatchQueue.main.async {
                        completion(result, error)
                    }
                }
            }
        }
    }
}
