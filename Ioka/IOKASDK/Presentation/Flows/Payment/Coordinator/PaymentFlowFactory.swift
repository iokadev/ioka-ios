//
//  PaymentFlowFactory.swift
//  Ioka
//
//  Created by ablai erzhanov on 05.04.2022.
//

import Foundation

class PaymentFlowFactory {
    let input: PaymentFlowInput
    let featuresFactory: FeaturesFactory
    
    
    init(input: PaymentFlowInput, featuresFactory: FeaturesFactory) {
        self.input = input
        self.featuresFactory = featuresFactory
    }
    
    func makeOrderForPayment(delegate: PaymentMethodsNavigationDelegate) -> ViewControllerProgressWrapper {
        featuresFactory.makeOrderForPayment(viewController: input.viewController, delegate: delegate, orderAccessToken: input.orderAccessToken)
    }
    
    
    func makePaymentMethods(delegate: PaymentMethodsNavigationDelegate, order: Order) -> PaymentMethodsViewController {
        featuresFactory.makePaymentMethods(delegate: delegate, orderAccessToken: input.orderAccessToken, order: order)
    }
    
    func make3DSecure(delegate: ThreeDSecureNavigationDelegate, url: URL, paymentId: String) -> ThreeDSecureViewController {
        featuresFactory.make3DSecure(delegate: delegate, state: .payment(repository: featuresFactory.paymentRepository(), orderAccessToken: input.orderAccessToken), url: url, cardId: nil, paymentId: paymentId)
    }
    
    func makePaymentResult(delegate: PaymentMethodsNavigationDelegate) -> PaymentResultViewController {
        featuresFactory.makePaymentResult(nil, delegate)
    }
    
}
