//
//  SavedCard.swift
//  Ioka
//
//  Created by ablai erzhanov on 06.04.2022.
//

import Foundation


internal struct SavedCard {
    
    enum Status {
        case succeeded
        case declined(APIError)
        case requiresAction(Action)
    }
    
    let status: Status
    let id: String
    var paymentSystem: String?
    var emitter: String?
    var holder: String?
}
