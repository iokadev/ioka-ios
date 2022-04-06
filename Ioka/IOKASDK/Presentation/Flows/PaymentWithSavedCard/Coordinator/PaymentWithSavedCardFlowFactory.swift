//
//  PaymentWithSavedCardFlowFactory.swift
//  Ioka
//
//  Created by ablai erzhanov on 05.04.2022.
//

import UIKit

struct PaymentWithSavedCardFlowInput {
    let setupInput: SetupInput
    let orderAccessToken: AccessToken
    let viewController: UIViewController
    let cardResponse: GetCardResponse
}


class PaymentWithSavedCardFlowFactory {
    let input: PaymentWithSavedCardFlowInput
    let featuresFactory: FeaturesFactory
    
    
    init(input: PaymentWithSavedCardFlowInput, featuresFactory: FeaturesFactory) {
        self.input = input
        self.featuresFactory = featuresFactory
    }
    
    
    func makeOrderForPayment(delegate: PaymentWithSavedCardNavigationDelegate) -> ViewControllerProgressWrapper {
        featuresFactory.makeOrderForSavedCardPayment(viewController: input.viewController, delegate: delegate, orderAccessToken: input.orderAccessToken)
    }
    
    func makeSavedCardPayment(delegate: PaymentWithSavedCardNavigationDelegate) -> CVVViewController {
        featuresFactory.makeSavedCardPayment(delegate: delegate, orderAccessToken: input.orderAccessToken, card: input.cardResponse)
    }
    
    func make3DSecure(delegate: ThreeDSecureNavigationDelegate, url: URL, paymentId: String) -> ThreeDSecureViewController {
        featuresFactory.make3DSecure(delegate: delegate, state: .payment(repository: featuresFactory.paymentRepository(), orderAccessToken: input.orderAccessToken), url: url, cardId: nil, paymentId: paymentId)
    }
    
    func makePaymentResult(delegate: PaymentWithSavedCardNavigationDelegate) -> PaymentResultViewController {
        featuresFactory.makePaymentResult(delegate, nil)
    }
    
    
}
