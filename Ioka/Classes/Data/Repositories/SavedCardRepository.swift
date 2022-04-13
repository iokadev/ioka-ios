//
//  SavedCardRepository.swift
//  Ioka
//
//  Created by ablai erzhanov on 06.04.2022.
//

import Foundation


internal final class SavedCardRepository {
    let api: IokaAPIProtocol
    
    init(api: IokaAPIProtocol) {
        self.api = api
    }
    
    func getSavedCards(customerAccessToken: AccessToken, completion: @escaping (Result<[SavedCardDTO], Error>) -> Void) {
        api.getCards(customerAccessToken: customerAccessToken, completion: completion)
    }
    
    func saveCard(customerAccessToken: AccessToken, cardParameters: CardParameters, completion: @escaping (Result<SavedCard, Error>) -> Void) {
        api.createBinding(customerAccessToken: customerAccessToken, card: cardParameters) { result in
            completion(result.toSavedCardsResult())
        }
    }
    
    func getStatus(customerAccessToken: AccessToken, cardId: String, completion: @escaping (Result<SavedCard, Error>) -> Void) {
        api.getCardByID(customerAccessToken: customerAccessToken, cardId: cardId) { result in
            completion(result.toSavedCardsResult())
        }
    }
}

extension Result where Success == SavedCardDTO {
    func toSavedCardsResult() -> Result<SavedCard, Error> {
        Result<SavedCard, Error> {
            switch self {
            case .success(let response):
                return try response.toSavedCard()
            case .failure(let error):
                throw error
            }
        }
    }
}
