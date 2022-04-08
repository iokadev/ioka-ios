//
//  DomainError.swift
//  IOKA
//
//  Created by Тимур Табынбаев on 05.04.2022.
//

import Foundation

internal enum DomainError: LocalizedError {
    case invalidTokenFormat
    case invalidPaymentStatus
    case noErrorForDeclinedStatus
    case noActionForRequiresActionStatus
    case invalidActionUrl
    
    var errorDescription: String? {
        switch self {
        default:
            return ""
        }
    }
}
