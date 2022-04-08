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
        API(apiKey: setupInput.apiKey)
    }()
    
    init(setupInput: SetupInput) {
        self.setupInput = setupInput
    }
    
    // MARK: - Features
    
    func makePaymentMethods(delegate: PaymentMethodsNavigationDelegate, orderAccessToken: AccessToken, order: Order, repository: PaymentRepository) -> PaymentMethodsViewController {
        let viewModel = PaymentMethodsViewModel(repository: repository, delegate: delegate, orderAccessToken: orderAccessToken, order: order)
        let vc = PaymentMethodsViewController()
        vc.viewModel = viewModel
        return vc
    }
    
    func makeOrderForPayment(viewController: UIViewController,delegate: PaymentMethodsNavigationDelegate, orderAccessToken: AccessToken, repository: OrderRepository) -> ViewControllerProgressWrapper{
        let viewModel = OrderForPaymentViewModel(repository: repository, delegate: delegate, orderAccessToken: orderAccessToken)
        let wrapper = ViewControllerProgressWrapper(viewController: viewController, viewModel: viewModel)
        return wrapper
    }
    
    func makeOrderForSavedCardPayment(viewController: UIViewController,delegate: PaymentWithSavedCardNavigationDelegate, orderAccessToken: AccessToken, repository: OrderRepository, card: GetCardResponse) -> ViewControllerProgressWrapper{
        let viewModel = PaymentWithSavedCardViewModel(delegate: delegate, repository: repository, orderAccessToken: orderAccessToken, card: card)
        let wrapper = ViewControllerProgressWrapper(viewController: viewController, viewModel: viewModel)
        return wrapper
    }
    
    func makeSavedCardPayment(delegate: PaymentWithSavedCardNavigationDelegate, orderAccessToken: AccessToken, card: GetCardResponse, repository: PaymentRepository) -> CVVViewController {
        let viewModel = CVVViewModel(delegate: delegate, repository: repository, orderAccessToken: orderAccessToken)
        let vc = CVVViewController()
        vc.card = card
        vc.modalPresentationStyle = .overFullScreen
        vc.viewModel = viewModel
        return vc
    }
    
    func makePaymentResult(_ delegateSavedCardPayment: PaymentWithSavedCardNavigationDelegate? , _ delegatePaymentMethods: PaymentMethodsNavigationDelegate?) -> PaymentResultViewController {
        let vc = PaymentResultViewController()
        if let delegate = delegateSavedCardPayment {
            let viewModel = PaymentResultViewModel(delegate: delegate)
            vc.viewModel = viewModel
            return vc
        } else if let delegate = delegatePaymentMethods {
            let viewModel = PaymentResultViewModel(delegate: delegate)
            vc.viewModel = viewModel
            return vc
        }
        return vc
    }
    
    func makeSaveCard(delegate: SaveCardNavigationDelegate, customerAccessToken: AccessToken, repository: SavedCardRepository) -> SaveCardViewController {
        let viewModel = SaveCardViewModel(delegate: delegate, repository: repository, customerAccessToken: customerAccessToken)
        let vc = SaveCardViewController()
        vc.viewModel = viewModel
        return vc
    }
    
    func make3DSecure(delegate: ThreeDSecureNavigationDelegate, state: ThreeDSecureState, url: URL, cardId: String?, paymentId: String?) -> ThreeDSecureViewController {
        let vc = ThreeDSecureViewController()
        vc.url = url
        let viewModel = ThreeDSecureViewModel(delegate: delegate, state: state, cardId: cardId, paymentId: paymentId)
        vc.viewModel = viewModel
        return vc
    }
    
    func makePaymentResultPopup(delegate: PaymentWithSavedCardNavigationDelegate) -> ErrorPopUpViewController {
        let viewModel = ErrorPopUpViewModel(delegate: delegate)
        let vc = ErrorPopUpViewController()
        vc.modalPresentationStyle = .overFullScreen
        vc.viewModel = viewModel
        return vc
    }
}
