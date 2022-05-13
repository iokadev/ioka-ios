//
//  ApplePayParameters.swift
//  Ioka
//
//  Created by ablai erzhanov on 13.05.2022.
//

import Foundation


struct CreatePaymentTokenParameters: Codable {
    var tool_type: String
    var apple_pay: ApplePayParameters
    var amount: Int
    var payer: ApplePayPayerParameters?
}

struct ApplePayParameters: Codable {
    var token: String
    var card_network: String
    var card_type: String
}

struct ApplePayPayerParameters: Codable {
    var email: String?
    var phone: String?
}
