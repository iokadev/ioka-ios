//
//  FlowResult.swift
//  Ioka
//
//  Created by ablai erzhanov on 08.04.2022.
//

import Foundation

/// Результат пользовательского сценария
public enum FlowResult: Equatable {
    /// Сценарий завершился успешно
    case succeeded
    /// Пользователь закрыл сценарий до завершения
    case cancelled
    /// Сценарий завершился неуспешно
    case failed(Error)
    
    public static func == (lhs: FlowResult, rhs: FlowResult) -> Bool {
        switch (lhs, rhs) {
        case (.succeeded, .succeeded):
            return true
        case (.cancelled, .cancelled):
            return true
        case (.failed, .failed):
            return true
        default:
            return false
        }
    }
    
    init(paymentResult: PaymentResult) {
        switch paymentResult {
        case .success:
            self = .succeeded
        case .error(let error):
            self = .failed(error)
        }
    }
}
