//
//  APIError.swift
//  Ioka
//
//  Created by ablai erzhanov on 05.04.2022.
//

import Foundation

internal typealias IokaError = Error

internal extension IokaError {
    var message: String {
        return localizedDescription
    }
}

// выше - заглушки, чтобы компилятор не ругался. По факту нужно будет по всему проекту заменить IokaError на Error

internal struct APIError: LocalizedError, Decodable {
    let code: String
    let message: String
    
    var errorDescription: String? {
        message
    }
}

internal extension APIError {
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
        case declinedByBankLimit = "DeclinedByBankLimit" // ?
        case customerExists = "CustomerExists"
        case cardNotFound = "CardNotFound"
        case bindingStarted = "BindingStarted"
        case bindingNotFound = "BindingNotFound"
        case webhookNotFound = "WebhookNotFound"
        case binNotFound = "BinNotFound"
    }
}
