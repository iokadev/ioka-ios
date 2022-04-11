//
//  Payment.swift
//  IOKA


import Foundation

internal struct Payment {
    enum Status {
        case succeeded
        case declined(APIError)
        case requiresAction(Action)
    }
    
    let id: String
    let status: Status
}
