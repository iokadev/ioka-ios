//
//  PaymentWithSavedCardFlowInput.swift
//  Ioka
//
//  Created by ablai erzhanov on 20.10.2022.
//

import Foundation


internal struct PaymentWithSavedCardFlowInput {
    let setupInput: SetupInput
    let orderAccessToken: AccessToken
    let card: SavedCard
    var showResultScreen: Bool
}
