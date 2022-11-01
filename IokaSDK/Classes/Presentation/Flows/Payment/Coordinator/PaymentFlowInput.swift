//
//  PaymentFlowInput.swift
//  Ioka
//
//  Created by ablai erzhanov on 05.04.2022.
//

import Foundation
import UIKit


internal struct PaymentFlowInput {
    let setupInput: SetupInput
    let orderAccessToken: AccessToken
    var applePayState: ApplePayState
    var showResultScreen: Bool
}
