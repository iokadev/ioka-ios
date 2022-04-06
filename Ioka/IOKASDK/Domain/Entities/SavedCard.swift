//
//  SavedCard.swift
//  Ioka
//
//  Created by ablai erzhanov on 06.04.2022.
//

import Foundation


struct SavedCard {
    
    enum Status {
        case succeeded
        case declined(APIError)
        case requiresAction(Action)
    }
    
    let status: Status
    let id: String
}
