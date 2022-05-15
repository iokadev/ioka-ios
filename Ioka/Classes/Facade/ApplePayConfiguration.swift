//
//  ApplePayConfiguration.swift
//  Ioka
//
//  Created by ablai erzhanov on 05.05.2022.
//

import Foundation
import PassKit

public enum ApplePayState {
    case disable
    case enable(applePayData: ApplePayData? = nil)
}

public struct ApplePayConfiguration {
    let merchantName: String //(для отображения в сумме заказа)
    let merchantIdentifier: String
    let countryCode: String
}


public struct ApplePayData {
    var summaryItems: [PKPaymentSummaryItem]
}
