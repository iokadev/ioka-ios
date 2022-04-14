//
//  SavedCardDTO+ToCardSaving.swift
//  Ioka
//
//  Created by ablai erzhanov on 06.04.2022.
//

import Foundation


extension SavedCardDTO {
    func toCardSaving() throws -> CardSaving {
        CardSaving(status: try status!.toCardSavingStatus(error: error, actionDTO: action), id: id)
    }
}

extension SavedCardDTO.Status {
    func toCardSavingStatus(error: APIError?, actionDTO: ActionDTO?) throws -> CardSaving.Status {
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
