//
//  PaymentTypeViewModel.swift
//  IOKA
//
//  Created by ablai erzhanov on 25.03.2022.
//

import Foundation

internal class PaymentTypeViewModel {
    func getCards(customerAccessToken: String, completion: @escaping([SavedCardDTO]?, Error?) -> Void) {
        

            Ioka.shared.getCards(customerAccessToken: customerAccessToken) {[weak self] result in
                print(result)
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
