//
//  FeaturesFactory.swift
//  Ioka
//
//  Created by ablai erzhanov on 05.04.2022.
//

import Foundation
import UIKit


internal struct FeaturesFactory {
    
    let setupInput: SetupInput
    private lazy var api: IokaAPIProtocol = {
        IokaApi(apiKey: setupInput.apiKey)
    }()
    
    init(setupInput: SetupInput) {
        self.setupInput = setupInput
    }
    
    // MARK: - Features
    
    func makePaymentMethods(delegate: PaymentMethodsNavigationDelegate, orderAccessToken: AccessToken, order: Order, repository: PaymentRepository, theme: IokaTheme) -> PaymentMethodsViewController {
        let viewModel = PaymentMethodsViewModel(repository: repository, delegate: delegate, orderAccessToken: orderAccessToken, order: order)
        let vc = PaymentMethodsViewController()
        vc.viewModel = viewModel
        vc.theme = theme
        return vc
    }
    
    func makeOrderForPayment(viewController: UIViewController, delegate: OrderForPaymentNavigationDelegate, orderAccessToken: AccessToken, repository: OrderRepository, theme: IokaTheme) -> ViewControllerProgressWrapper{
        let viewModel = OrderForPaymentViewModel(repository: repository, delegate: delegate, orderAccessToken: orderAccessToken)
        let wrapper = ViewControllerProgressWrapper(viewController: viewController, viewModel: viewModel)
        wrapper.theme = theme
        return wrapper
    }
    
    func makeSavedCardPayment(viewController: UIViewController,delegate: PaymentWithSavedCardNavigationDelegate, orderAccessToken: AccessToken, repository: OrderRepository, card: SavedCard, theme: IokaTheme) -> ViewControllerProgressWrapper{
        let viewModel = PaymentWithSavedCardViewModel(delegate: delegate, repository: repository, orderAccessToken: orderAccessToken, card: card)
        let wrapper = ViewControllerProgressWrapper(viewController: viewController, viewModel: viewModel)
        wrapper.theme = theme
        return wrapper
    }
    
    func makeCVVSavedCardPayment(delegate: CVVNavigationDelegate, orderAccessToken: AccessToken, card: SavedCard, repository: PaymentRepository) -> CVVViewController {
        let viewModel = CVVViewModel(delegate: delegate, repository: repository, orderAccessToken: orderAccessToken)
        let vc = CVVViewController()
        vc.card = card
        vc.viewModel = viewModel
        return vc
    }
    
    func makePaymentResult(delegate: PaymentResultNavigationDelegate, order: Order, result: PaymentResult) -> PaymentResultViewController {
        let vc = PaymentResultViewController()
        let viewModel = PaymentResultViewModel(order: order, result: result, delegate: delegate)
        vc.viewModel = viewModel
        
        return vc
    }
    
    func makeSaveCard(delegate: SaveCardNavigationDelegate, customerAccessToken: AccessToken, repository: SavedCardRepository, theme: IokaTheme) -> SaveCardViewController {
        let viewModel = SaveCardViewModel(delegate: delegate, repository: repository, customerAccessToken: customerAccessToken)
        let vc = SaveCardViewController()
        vc.viewModel = viewModel
        vc.theme = theme
        return vc
    }
    
    func make3DSecure(delegate: ThreeDSecureNavigationDelegate, state: ThreeDSecureState, url: URL, cardId: String?, paymentId: String?, theme: IokaTheme) -> ThreeDSecureViewController {
        let vc = ThreeDSecureViewController()
        vc.url = url
        let viewModel = ThreeDSecureViewModel(delegate: delegate, state: state, cardId: cardId, paymentId: paymentId)
        vc.viewModel = viewModel
        vc.theme = theme
        return vc
    }
    
    func makePaymentResultPopup(delegate: ErrorPopupNavigationDelegate, error: Error) -> ErrorPopupViewController {
        let viewModel = ErrorPopupViewModel(error: error, delegate: delegate)
        let vc = ErrorPopupViewController()
        vc.viewModel = viewModel

        return vc
    }
}
