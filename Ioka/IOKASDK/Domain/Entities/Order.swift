//
//  Order.swift
//  Ioka
//
//  Created by ablai erzhanov on 06.04.2022.
//

import Foundation


struct Order {
    
    let id: String
    var externalId: String?
    var hasCustomerId: Bool
    // isExpired и isPaid можно убрать. все равно не используем же
    var isExpired: Bool = false
    var isPaid: Bool = false
    var price: Int
    // currency не нужно?
}
