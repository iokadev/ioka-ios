//
//  Card.swift
//  iOKA
//
//  Created by ablai erzhanov on 02.03.2022.
//

import Foundation


internal struct CardParameters: Codable {
    var pan: String?
    var exp: String?
    var cvc: String?
    var holder: String?
    var save: Bool?
    var email: String?
    var phone: String?
    var card_id: String?
    
    init(pan: String, exp: String, cvc: String, save: Bool? = nil) {
        self.pan = pan
        self.exp = exp
        self.cvc = cvc
        self.save = save
    }
    
    init(cardId: String, cvc: String? = nil) {
        self.card_id = cardId
        self.cvc = cvc
    }
}
