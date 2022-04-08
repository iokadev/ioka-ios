//
//  GetOrderResponse.swift
//  IOKA
//
//  Created by ablai erzhanov on 04.04.2022.
//

import Foundation


internal struct GetOrderResponse: Codable {
    
    let id: String //-Идентификатор платежа
    let status: String
    let created_at: String //-Время создания платежа
    let amount: Int
    let currency: String
    let capture_method: String
    var external_id: String? //
    var description: String? //
    var extra_info: String? //
    var attempts: Int? //-
    var due_date: String? //-
    var customer_id: String?//-
    var card_id: String? //
    var back_url: String? //-
    var success_url: String? //-
    var failure_url: String?//-
    var template: String? //-
    var checkout_url: String?//-
    
    var hasCustomerId: Bool {
        if customer_id == nil {
            return false
        } else {
            return true
        }
    }
}
