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
    
    func getSavedCards(customerAccessToken: AccessToken, completion: @escaping (Result<[SavedCard], Error>) -> Void) {
        api.getCards(customerAccessToken: customerAccessToken) { result in
            completion(result.map { $0.map { $0.toSavedCard() } } )
        }
    }
    
    func saveCard(customerAccessToken: AccessToken, cardParameters: CardParameters, completion: @escaping (Result<CardSaving, Error>) -> Void) {
        api.createBinding(customerAccessToken: customerAccessToken, card: cardParameters) { result in
            completion(result.toCardSavingResult())
        }
    }
    
    func getStatus(customerAccessToken: AccessToken, cardId: String, completion: @escaping (Result<CardSaving, Error>) -> Void) {
        api.getCardByID(customerAccessToken: customerAccessToken, cardId: cardId) { result in
            completion(result.toCardSavingResult())
        }
    }

    func getSavedCardById(customerAccessToken: AccessToken, cardId: String, completion: @escaping (Result<SavedCard, Error>) -> Void) {
        api.getCardByID(customerAccessToken: customerAccessToken, cardId: cardId) { result in
            completion(result.toSavedCard())
        }
    }
}

extension Result where Success == SavedCardDTO {
    func toCardSavingResult() -> Result<CardSaving, Error> {
        Result<CardSaving, Error> {
            switch self {
            case .success(let response):
                return try response.toCardSaving()
            case .failure(let error):
                throw error
            }
        }
    }

    func toSavedCard() -> Result<SavedCard, Error> {
        Result<SavedCard, Error> {
            switch self {
            case .success(let response):
                return response.toSavedCard()
            case .failure(let error):
                throw error
            }
        }
    }
}
