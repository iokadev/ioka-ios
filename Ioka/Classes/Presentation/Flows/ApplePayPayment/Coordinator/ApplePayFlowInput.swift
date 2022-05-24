//
//  ApplePayFlowInput.swift
//  Ioka
//
//  Created by ablai erzhanov on 24.05.2022.
//

import Foundation
import PassKit


struct ApplePayFlowInput {
    let setupInput: SetupInput
    var orderAccessToken: AccessToken
    var request: PKPaymentRequest
}
