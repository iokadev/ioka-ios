//
//  ApplePayParameters.swift
//  Ioka
//
//  Created by ablai erzhanov on 13.05.2022.
//

import Foundation


struct CreatePaymentTokenParameters: Codable {
    var tool_type: String = "APPLE_PAY"
    var apple_pay: ApplePayParameters
}

struct ApplePayParameters: Codable {
    var paymentData: ApplePayPaymentData
    var paymentMethod: ApplePayPaymentMethod
    var transactionIdentifier: String
}

struct ApplePayPaymentData: Codable {
    var data: String
    var header: PaymentDataHeader
    var signature: String
    var version: String
}

struct PaymentDataHeader: Codable {
    var ephemeralPublicKey: String
    var publicKeyHash: String
    var transactionId: String
}

struct ApplePayPaymentMethod: Codable {
    var displayName: String
    var network: String
    var type: String
}
