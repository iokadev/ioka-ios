//
//  ApplePayFlowFactory.swift
//  Ioka
//
//  Created by ablai erzhanov on 24.05.2022.
//

import Foundation

internal class ApplePayFlowFactory {
    let input: ApplePayFlowInput
    let featuresFactory: FeaturesFactory


    init(input: ApplePayFlowInput, featuresFactory: FeaturesFactory) {
        self.input = input
        self.featuresFactory = featuresFactory
    }

    func makeApplePay(delegate: ApplePayNavigationDelegate) -> ApplePayViewController {
        featuresFactory.makeApplePay(applePayRepository: applePayRepository(), orderAccessToken: input.orderAccessToken, request: input.request, delegate: delegate)
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

    func applePayRepository() -> ApplePayRepository {
        ApplePayRepository(api: api)
    }

    func paymentRepository() -> PaymentRepository {
        PaymentRepository(api: api)
    }

    private lazy var api: IokaAPIProtocol = {
        IokaApi(apiKey: input.setupInput.apiKey)
    }()
}
