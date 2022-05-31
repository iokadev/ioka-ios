//
//  ApplePayService.swift
//  Ioka
//
//  Created by ablai erzhanov on 24.05.2022.
//

import Foundation
import PassKit


struct ApplePayService {

    func createApplePayRequest(order: Order, applePayConfiguration: ApplePayConfiguration, applePayData: ApplePayData?) -> PKPaymentRequest {

        let paymentSummaryItems = applePayData?.summaryItems ?? [PKPaymentSummaryItem(label: applePayConfiguration.merchantName, amount: NSDecimalNumber(value: order.amount / 100), type: .final)]

        let currencyCode = order.currency
        let supportedNetworks = self.getSupportedNetworks()
        let capability: PKMerchantCapability = .capability3DS

        let request = PKPaymentRequest()
        request.merchantIdentifier = applePayConfiguration.merchantIdentifier
        request.paymentSummaryItems = paymentSummaryItems
        request.currencyCode = currencyCode
        request.supportedNetworks = supportedNetworks
        request.merchantCapabilities = capability
        request.countryCode = applePayConfiguration.countryCode

        return request
    }

    func applePayIsAvailable() -> Bool {
        PKPaymentAuthorizationViewController.canMakePayments(usingNetworks: getSupportedNetworks())
    }

    func getSupportedNetworks() -> [PKPaymentNetwork] {
        if #available(iOS 14.5, *) {
            return [.discover, .amex, .visa, .masterCard, .mir, .chinaUnionPay]
        } else {
            return [.discover, .amex, .visa, .masterCard, .chinaUnionPay]
        }
    }
}
