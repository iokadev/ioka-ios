//
//  PaymentWithSavedCardFlowFactory.swift
//  Ioka
//
//  Created by ablai erzhanov on 05.04.2022.
//

import UIKit

internal struct PaymentWithSavedCardFlowInput {
    let setupInput: SetupInput
    let orderAccessToken: AccessToken
    let card: SavedCard
}


internal class PaymentWithSavedCardFlowFactory {
    let input: PaymentWithSavedCardFlowInput
    let featuresFactory: FeaturesFactory
    
    
    init(input: PaymentWithSavedCardFlowInput, featuresFactory: FeaturesFactory) {
        self.input = input
        self.featuresFactory = featuresFactory
    }
    
    
    func makeSavedCardPayment(delegate: PaymentWithSavedCardNavigationDelegate, sourceViewController: UIViewController) -> ViewControllerProgressWrapper {
        featuresFactory.makeSavedCardPayment(viewController: sourceViewController, delegate: delegate, orderAccessToken: input.orderAccessToken, repository: orderRepository(), card: input.card)
    }
    
    func makeCVVSavedCardPayment(delegate: CVVNavigationDelegate) -> CVVViewController {
        featuresFactory.makeCVVSavedCardPayment(delegate: delegate, orderAccessToken: input.orderAccessToken, card: input.card, repository: paymentRepository())
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
    
    func makePaymentResultPopup(delegate: ErrorPopupNavigationDelegate, error: Error) -> ErrorPopupViewController {
        featuresFactory.makePaymentResultPopup(delegate: delegate, error: error)
    }
    
    func paymentRepository() -> PaymentRepository {
        PaymentRepository(api: api)
    }
    
    func orderRepository() -> OrderRepository {
        OrderRepository(api: api)
    }
    
    private lazy var api: IokaAPIProtocol = {
        IokaApi(apiKey: input.setupInput.apiKey)
    }()
}
