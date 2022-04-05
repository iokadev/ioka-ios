//
//  Payment.swift
//  IOKA
//
//  Created by Тимур Табынбаев on 05.04.2022.
//

import Foundation

struct Payment {
    enum Status {
        case succeeded
        case declined(APIError)
        case requiresAction(Action)
    }
    
    let id: String
    let status: Status
}
