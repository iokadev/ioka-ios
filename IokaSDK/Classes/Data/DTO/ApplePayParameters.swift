//
//  ApplePayParameters.swift
//  Ioka
//
//  Created by ablai erzhanov on 13.05.2022.
//

import Foundation
import PassKit


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

    init(paymentData: Data) throws {

        let paymentData = try JSONDecoder().decode(ApplePayPaymentData.self, from: paymentData)

        self.data = paymentData.data
        self.header = paymentData.header
        self.signature = paymentData.signature
        self.version = paymentData.version
    }
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

    init(displayName: String, network: String, pkPaymentMethodType: PKPaymentMethodType) {
        self.displayName = displayName
        self.network = network
        switch pkPaymentMethodType {
        case .unknown:
            self.type = "unknown"
        case .debit:
            self.type = "debit"
        case .credit:
            self.type = "credit"
        case .prepaid:
            self.type = "prepaid"
        case .store:
            self.type = "store"
        case .eMoney:
            self.type = "eMoney"
        @unknown default:
            fatalError("Unknown type was inferred")
        }
    }
}
