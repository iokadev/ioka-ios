//
//  PaymentDTO+ToPayment.swift
//  IOKA


import Foundation

extension PaymentDTO {
    func toPayment() throws -> Payment {
        Payment(id: id,
                status: try status.toPaymentStatus(error: error, actionDTO: action))
    }
}

extension PaymentDTO.Status {
    func toPaymentStatus(error: APIError?, actionDTO: ActionDTO?) throws -> Payment.Status {
        switch self {
        case .PENDING, .CANCELLED:
            throw DomainError.invalidPaymentStatus
        case .APPROVED, .CAPTURED:
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
            return .requiresAction(try actionDTO.toAction())
        }
    }
}
