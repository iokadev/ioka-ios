//
//  Error.swift
//  iOKA
//
//  Created by ablai erzhanov on 03.03.2022.
//

import Foundation


struct IokaError: Codable {
    let code: ErrorCodes?
    let message: String
}


enum ErrorCodes: String, Codable {
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
    case customerExists = "CustomerExists"
    case cardNotFound = "CardNotFound"
    case bindingStarted = "BindingStarted"
    case bindingNotFound = "BindingNotFound"
    case webhookNotFound = "WebhookNotFound"
    case binNotFound = "BinNotFound"
    case networkError = "NetworkError"
    case noData = "No data"
    case `default` = "Indefined error status code"
}
