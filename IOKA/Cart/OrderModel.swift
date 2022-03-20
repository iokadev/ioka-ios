//
//  ProductModel.swift
//  iOKA
//
//  Created by ablai erzhanov on 09.03.2022.
//

import Foundation


struct OrderModel: Codable {
    let orderPrice: String
    let orderTitle: String
    let orderNumber: String
    let orderImageUrl: String?
    let orderAdress: String?
    let orderTime: String?
}

extension OrderModel {
    static var models: [OrderModel] = [OrderModel(orderPrice: "148490", orderTitle: "Набор керамики", orderNumber: "248241", orderImageUrl: nil, orderAdress: "улица Абая, 328", orderTime: "14 марта, 16:00")]
}