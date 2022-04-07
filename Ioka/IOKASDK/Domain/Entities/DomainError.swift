//
//  DomainError.swift
//  IOKA
//
//  Created by Тимур Табынбаев on 05.04.2022.
//

import Foundation

enum DomainError: LocalizedError {
    case invalidTokenFormat
    case invalidPaymentStatus
    case noErrorForDeclinedStatus
    case noActionForRequiresActionStatus
    case invalidActionUrl
    
    // REVIEW: Это ещё надо локализовать
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
