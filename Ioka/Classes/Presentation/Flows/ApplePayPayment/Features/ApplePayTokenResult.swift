//
//  ApplePayTokenResult.swift
//  Ioka
//
//  Created by ablai erzhanov on 31.05.2022.
//

import Foundation


enum ApplePayTokenResult {
    case succeed
    case failure(error: Error)
    case applePayDidFail(declineError: Error)
    case requiresAction(action: Action, payment: Payment)
}
