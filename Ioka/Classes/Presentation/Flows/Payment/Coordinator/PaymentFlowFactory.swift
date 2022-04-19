//
//  PaymentFlowFactory.swift
//  Ioka
//
//  Created by ablai erzhanov on 05.04.2022.
//

import Foundation

internal class PaymentFlowFactory {
    let input: PaymentFlowInput
    let featuresFactory: FeaturesFactory
    
    
    init(input: PaymentFlowInput, featuresFactory: FeaturesFactory) {
        self.input = input
        self.featuresFactory = featuresFactory
    }
    
    func makeOrderForPayment(delegate: OrderForPaymentNavigationDelegate, sourceViewController: UIViewController) -> ViewControllerProgressWrapper {
        featuresFactory.makeOrderForPayment(viewController: sourceViewController, delegate: delegate, orderAccessToken: input.orderAccessToken, repository: orderRepository())
    }
    
    func makePaymentMethods(delegate: PaymentMethodsNavigationDelegate, order: Order) -> PaymentMethodsViewController {
        featuresFactory.makePaymentMethods(delegate: delegate, orderAccessToken: input.orderAccessToken, order: order, repository: paymentRepository())
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
        return PaymentRepository(api: api)
    }
    
    func orderRepository() -> OrderRepository {
        return OrderRepository(api: api)
    }
    
    private lazy var api: IokaAPIProtocol = {
        IokaApi(apiKey: input.setupInput.apiKey)
    }()
}
