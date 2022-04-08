//
//  SavedCardsViewModel.swift
//  IOKA
//
//  Created by ablai erzhanov on 25.03.2022.
//

import Foundation


internal class SavedCardsViewModel {
    
    
    func getCards(customerAccessToken: String, completion: @escaping([GetCardResponse]?) -> Void) {
        let queue = DispatchQueue.global(qos: .userInitiated)
        queue.async {
            Ioka.shared.getCards(customerAccessToken: customerAccessToken) { [weak self] result in
                guard let _ = self else { return }
                
                switch result {
                case .success(let cards):
                    DispatchQueue.main.async {
                        completion(cards)
                    }
                case .failure( _):
                    DispatchQueue.main.async {
                       completion(nil)
                    }
                }
            }
        }
    }
}
