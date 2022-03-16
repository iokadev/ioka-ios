//
//  Card.swift
//  iOKA
//
//  Created by ablai erzhanov on 02.03.2022.
//

import Foundation



struct Card: Codable {
    let pan: String
    let exp: String
    let cvc: String
    var holder: String?
    var save: Bool?
    var email: String?
    var phone: String?
    var card_id: String?
}
