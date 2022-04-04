//
//  Card.swift
//  iOKA
//
//  Created by ablai erzhanov on 02.03.2022.
//

import Foundation



struct Card: Decodable {
    var pan: String?
    var exp: String?
    var cvc: String?
    var holder: String?
    var save: Bool?
    var email: String?
    var phone: String?
    var card_id: String?
    
    init(pan: String, exp: String, cvc: String) {
        self.pan = pan
        self.exp = exp
        self.cvc = cvc
    }
    
    init(cardId: String, cvc: String?) {
        self.card_id = cardId
        self.cvc = cvc
    }
}
