//
//  SavedCardDTO+toSavedCard.swift
//  Ioka
//
//  Created by ablai erzhanov on 06.04.2022.
//

import Foundation


extension GetCardResponse {
    func toSavedCard() throws -> SavedCard {
        SavedCard(status: try status!.toSavedCardStatus(error: error, actionDTO: action), id: id)
    }
}

extension SavedCardStatus {
    func toSavedCardStatus(error: APIError?, actionDTO: ActionDTO?) throws -> SavedCard.Status {
        switch self {
        case .PENDING:
            throw DomainError.invalidPaymentStatus
        case .APPROVED:
            return .succeeded
        case .DECLINED:
            if let error = error {
                return .declined(error)
            } else {
                throw DomainError.noErrorForDeclinedStatus
            }
        case .REQUIRES_ACTION:
            guard let actionDTO = actionDTO else {
                throw DomainError.noActionForRequiresActionStatus
            }
            
            return  .requiresAction(try actionDTO.toAction())
        }
    }
}
