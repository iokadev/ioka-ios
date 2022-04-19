//
//  FeaturesFactory.swift
//  Ioka
//
//  Created by ablai erzhanov on 05.04.2022.
//

import Foundation
import UIKit


internal struct FeaturesFactory {
    func makePaymentMethods(delegate: PaymentMethodsNavigationDelegate, orderAccessToken: AccessToken, order: Order, paymentRepository: PaymentRepository, cardInfoRepository: CardInfoRepository) -> PaymentMethodsViewController {
        let cardFormViewModel = CardFormViewModel(repository: cardInfoRepository)
        let viewModel = PaymentMethodsViewModel(delegate: delegate,
                                                repository: paymentRepository,
                                                orderAccessToken: orderAccessToken,
                                                order: order,
                                                cardFormViewModel: cardFormViewModel)
        let vc = PaymentMethodsViewController()
        vc.viewModel = viewModel

        return vc
    }
    
    func makeOrderForPayment(viewController: UIViewController, delegate: OrderForPaymentNavigationDelegate, orderAccessToken: AccessToken, repository: OrderRepository) -> ViewControllerProgressWrapper{
        let viewModel = OrderForPaymentViewModel(repository: repository, delegate: delegate, orderAccessToken: orderAccessToken)
        let wrapper = ViewControllerProgressWrapper(viewController: viewController, viewModel: viewModel)
        
        return wrapper
    }
    
    func makeSavedCardPayment(viewController: UIViewController,delegate: PaymentWithSavedCardNavigationDelegate, orderAccessToken: AccessToken, repository: OrderRepository, card: SavedCard) -> ViewControllerProgressWrapper{
        let viewModel = PaymentWithSavedCardViewModel(delegate: delegate, repository: repository, orderAccessToken: orderAccessToken, card: card)
        let wrapper = ViewControllerProgressWrapper(viewController: viewController, viewModel: viewModel)

        return wrapper
    }
    
    func makeCVVSavedCardPayment(delegate: CVVNavigationDelegate, orderAccessToken: AccessToken, card: SavedCard, repository: PaymentRepository) -> CVVViewController {
        let viewModel = CVVViewModel(delegate: delegate, card: card, repository: repository, orderAccessToken: orderAccessToken)
        let vc = CVVViewController()
        vc.viewModel = viewModel
        
        return vc
    }
    
    func makePaymentResult(delegate: PaymentResultNavigationDelegate, order: Order, result: PaymentResult) -> PaymentResultViewController {
        let vc = PaymentResultViewController()
        let viewModel = PaymentResultViewModel(order: order, result: result, delegate: delegate)
        vc.viewModel = viewModel
        
        return vc
    }
    
    func makeSaveCard(delegate: SaveCardNavigationDelegate, customerAccessToken: AccessToken, savedCardRepository: SavedCardRepository, cardInfoRepository: CardInfoRepository) -> SaveCardViewController {
        let cardFormViewModel = CardFormViewModel(repository: cardInfoRepository)

        let viewModel = SaveCardViewModel(delegate: delegate,
                                          repository: savedCardRepository,
                                          customerAccessToken: customerAccessToken,
                                          cardFormViewModel: cardFormViewModel)
        let vc = SaveCardViewController()
        vc.viewModel = viewModel

        return vc
    }
    
    func makeThreeDSecure(delegate: ThreeDSecureNavigationDelegate, action: Action, input: ThreeDSecureInput) -> ThreeDSecureViewController {
        let vc = ThreeDSecureViewController()
        let viewModel = ThreeDSecureViewModel(delegate: delegate, action: action, input: input)
        vc.viewModel = viewModel

        return vc
    }
    
    func makePaymentResultPopup(delegate: ErrorPopupNavigationDelegate, error: Error) -> ErrorPopupViewController {
        let viewModel = ErrorPopupViewModel(error: error, delegate: delegate)
        let vc = ErrorPopupViewController()
        vc.viewModel = viewModel

        return vc
    }
}
