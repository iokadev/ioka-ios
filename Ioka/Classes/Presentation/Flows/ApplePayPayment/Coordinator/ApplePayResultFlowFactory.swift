//
//  ApplePayFlowFactory.swift
//  Ioka
//
//  Created by ablai erzhanov on 24.05.2022.
//

import Foundation

internal class ApplePayResultFlowFactory {
    let input: ApplePayFlowInput
    let featuresFactory: FeaturesFactory


    init(input: ApplePayFlowInput, featuresFactory: FeaturesFactory) {
        self.input = input
        self.featuresFactory = featuresFactory
    }

    func makeThreeDSecure(delegate: ThreeDSecureNavigationDelegate, action: Action, paymentId: String) -> ThreeDSecureViewController {
        featuresFactory.makeThreeDSecure(delegate: delegate,
                                         action: action,
                                         input: .payment(repository: paymentRepository(),
                                                         orderAccessToken: input.orderAccessToken,
                                                         paymentId: paymentId))
    }

    func makePaymentResult(delegate: PaymentResultNavigationDelegate, order: Order, result: PaymentResult) -> PaymentResultViewController {
        featuresFactory.makePaymentResult(delegate: delegate, order: order, result: result)
    }

    func paymentRepository() -> PaymentRepository {
        PaymentRepository(api: api)
    }

    private lazy var api: IokaAPIProtocol = {
        IokaApi(apiKey: input.setupInput.apiKey)
    }()
}
