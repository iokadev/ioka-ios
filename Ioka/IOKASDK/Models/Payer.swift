//
//  Payer.swift
//  iOKA
//
//  Created by ablai erzhanov on 02.03.2022.
//

import Foundation


internal struct Payer: Codable {
    let pan_masked: String
    let expiry_date: String
    var holder: String?
    var payment_system: PaymentSystem?
    var emitter: String?
    var email: String?
    var phone: String?
    var customer_id: String?
    var card_id: String?
}
