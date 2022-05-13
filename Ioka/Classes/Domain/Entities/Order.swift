//
//  Order.swift
//  Ioka
//
//  Created by ablai erzhanov on 06.04.2022.
//

import Foundation


internal struct Order {
    
    let id: String
    var externalId: String?
    var hasCustomerId: Bool
    var price: Int
    var currency: String
    var amount: Int
}
