//
//  ProductModel.swift
//  iOKA
//
//  Created by ablai erzhanov on 09.03.2022.
//

import Foundation


internal struct OrderModel: Codable {
    let orderPrice: String
    let orderTitle: String
    let orderNumber: String
    let orderImageUrl: String?
    let orderAdress: String?
    let orderTime: String?

    var priceInt: Int {
        return Int(orderPrice) ?? 148000
    }
}

extension OrderModel {
    static var models: [OrderModel] = [OrderModel(orderPrice: "148490", orderTitle: "Набор керамики", orderNumber: "248241", orderImageUrl: nil, orderAdress: "улица Абая, 328", orderTime: "14 марта, 16:00")]
}
