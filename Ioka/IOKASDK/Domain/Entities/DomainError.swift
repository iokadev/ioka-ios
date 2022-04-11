//
//  DomainError.swift
//  IOKA

import Foundation

internal enum DomainError: LocalizedError {
    case invalidTokenFormat
    case invalidPaymentStatus
    case noErrorForDeclinedStatus
    case noActionForRequiresActionStatus
    case invalidActionUrl
    
    var errorDescription: String? {
        switch self {
        case .invalidTokenFormat:
            return "Некорректный формат токена"
        case .invalidPaymentStatus:
            return "Некорректный статус платежа"
        case .noErrorForDeclinedStatus:
            return "Остутствует объект ошибки для статуса Declined"
        case .noActionForRequiresActionStatus:
            return "Отсутствует объект Action для статуса RequiresAction"
        case .invalidActionUrl:
            return "Некорректный Action URL"
        }
    }
}
