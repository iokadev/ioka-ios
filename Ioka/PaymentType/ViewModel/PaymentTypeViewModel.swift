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
            IOKA.shared.getCards(customerAccessToken: customerAccessToken) {[weak self] result in
                
                guard let _ = self else { return }
                switch result {
                case .success(let cards):
                    completion(cards, nil)
                case .failure(let error):
                    completion(nil, error)
                }
            }
        }
    }
}
