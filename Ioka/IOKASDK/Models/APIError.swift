//
//  APIError.swift
//  Ioka
//
//  Created by ablai erzhanov on 05.04.2022.
//

import Foundation

typealias IokaError = Error

extension IokaError {
    var message: String {
        return localizedDescription
    }
}

// REVIEW: выше - заглушки, чтобы компилятор не ругался. По факту нужно будет по всему проекту заменить IokaError на Error

struct APIError: LocalizedError, Decodable {
    let code: Code
    let message: String
    
    var errorDescription: String? {
        message
    }
}

extension APIError {
    enum Code: String, Decodable {
        case unauthorized = "Unauthorized"
        case forbidden = "Forbidden"
        case invalidRequest = "InvalidRequest"
        case badGateway = "BadGateway"
        case orderNotFound = "OrderNotFound"
        case orderExists = "OrderExists"
        case orderUnpaid = "OrderUnpaid"
        case orderHasApprovedPayment = "OrderHasApprovedPayment"
        case orderHasNoApprovedPayment = "OrderHasNoApprovedPayment"
        case orderHasNoAttemptsLeftError = "OrderHasNoAttemptsLeftError"
        case orderExpired = "OrderExpired"
        case paymentNotFound = "PaymentNotFound"
        case refundNotFound = "RefundNotFound"
        case paymentStarted = "PaymentStarted"
        case processingDeadlineReachedError = "ProcessingDeadlineReachedError"
        case paymentCaptureAmountExceeded = "PaymentCaptureAmountExceeded"
        case paymentRefundAmountExceededError = "PaymentRefundAmountExceededError"
        case invalidPaymentToken = "InvalidPaymentToken"
        case paymentTokenNotFound = "PaymentTokenNotFound"
        case customerNotFound = "CustomerNotFound"
        
        // REVIEW: это откуда?
        case DECLINED_BY_BANK_LIMIT = "DECLINED_BY_BANK_LIMIT"
        case customerExists = "CustomerExists"
        case cardNotFound = "CardNotFound"
        case bindingStarted = "BindingStarted"
        case bindingNotFound = "BindingNotFound"
        case webhookNotFound = "WebhookNotFound"
        case binNotFound = "BinNotFound"
        
        // REVIEW: нужно добавить case Undefined и написать кастомный декодинг. Чтобы в случае если появится новый код ошибки, у нас приложение нормально это обработало.
    }
}
