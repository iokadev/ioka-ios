//
//  OrderDTO+toOrder.swift
//  Ioka
//
//  Created by ablai erzhanov on 06.04.2022.
//

import Foundation


extension GetOrderResponse {
    func toOrder() throws -> Order {
        Order(id: id, externalId: external_id, hasCustomerId: hasCustomerId, price: amount)
    }
}
