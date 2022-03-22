//
//  IokaBrowserState.swift
//  IOKA
//
//  Created by ablai erzhanov on 16.03.2022.
//

import Foundation



enum IokaBrowserState {
    case createCardPayment(orderId: String, paymentId: String)
    case createBinding(customerId: String, cardId: String)
}
