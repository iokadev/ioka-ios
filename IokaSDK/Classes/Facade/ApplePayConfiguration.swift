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

    public init(merchantName: String, merchantIdentifier: String, countryCode: String) {
        self.merchantName = merchantName
        self.merchantIdentifier = merchantIdentifier
        self.countryCode = countryCode
    }
}


public struct ApplePayData {
    public var summaryItems: [PKPaymentSummaryItem]
}
