//
//  GetOrderResponse.swift
//  IOKA
//
//  Created by ablai erzhanov on 04.04.2022.
//

import Foundation


internal struct OrderDTO: Codable {
    
    let id: String //-Идентификатор платежа
    let status: String
    let created_at: String //-Время создания платежа
    let amount: Int
    let currency: String
    let capture_method: String
    var external_id: String? //
    var customer_id: String?//
    
    var hasCustomerId: Bool {
        if customer_id == nil {
            return false
        } else {
            return true
        }
    }
}
