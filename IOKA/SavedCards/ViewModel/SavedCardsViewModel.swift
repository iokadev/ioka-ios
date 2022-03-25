//
//  SavedCardsViewModel.swift
//  IOKA
//
//  Created by ablai erzhanov on 25.03.2022.
//

import Foundation


class SavedCardsViewModel {
    
    
    func getCards(customerAccessToken: String, completion: @escaping([GetCardResponse]?) -> Void) {
        let queue = DispatchQueue.global(qos: .userInitiated)
        queue.async {
            IOKA.shared.getCards(customerAccessToken: customerAccessToken) { [weak self] getCardsResponse, error in
                guard let _ = self else { return }
                if let getCardsResponse = getCardsResponse {
                    DispatchQueue.main.async {
                        completion(getCardsResponse)
                    }
                }
                if error != nil {
                    DispatchQueue.main.async {
                       completion(nil)
                    }
                }
            }
        }
    }
}
