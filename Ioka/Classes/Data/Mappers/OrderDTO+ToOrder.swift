//
//  OrderDTO+toOrder.swift
//  Ioka
//
//  Created by ablai erzhanov on 06.04.2022.
//

import Foundation


extension OrderDTO {
    func toOrder() -> Order {
        Order(id: id, externalId: external_id, hasCustomerId: hasCustomerId, price: amount, currency: currency)
    }
}
