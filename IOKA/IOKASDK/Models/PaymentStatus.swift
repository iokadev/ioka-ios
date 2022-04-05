//
//  PaymentStatus.swift
//  iOKA
//
//  Created by ablai erzhanov on 02.03.2022.
//

import Foundation

// Это нужно сделать как nested type внутри PaymentDTO. С названием Status.
enum PaymentStatus: String, Decodable {
    case PENDING = "PENDING"
    case APPROVED = "APPROVED"
    case CAPTURED = "CAPTURED"
    case CANCELLED = "CANCELLED"
    case DECLINED = "DECLINED"
    case REQUIRES_ACTION = "REQUIRES_ACTION"
}
