//
//  Factory.swift
//  iOKA
//
//  Created by ablai erzhanov on 09.03.2022.
//

import Foundation


class IokaFactory {
    static let shared = IokaFactory()
    
    func initiateCardPaymentViewController(orderAccesToken: String?, delegate: CardPaymentNavigationDelegate) -> CardPaymentViewController {
        guard let orderAccesToken = orderAccesToken else { fatalError("Please provide order_access_token") }
        let viewController = CardPaymentViewController()
        viewController.order_id = orderAccesToken.trimTokens()
        viewController.viewModel = CardPaymentViewModel()
        return viewController
    }
    
    func initiatePaymentResultViewController(paymentResult: PaymentResult, error: IokaError?, response: CardPaymentResponse?, delegate: PaymentResultNavigationDelegate) -> PaymentResultViewController {
        let viewController = PaymentResultViewController()
        viewController.contentView.paymentResult = paymentResult
        viewController.contentView.error = error
        viewController.contentView.orderResponse = response
        viewController.viewModel = PaymentResultViewModel()
        return viewController
    }
    
    func initiateIokaBrowserViewController(url: String, delegate: IokaBrowserViewControllerDelegate, iokaBrowserState: IokaBrowserState) -> IokaBrowserViewController {
        let viewController = IokaBrowserViewController()
        viewController.url = URL(string: url)!
        viewController.delegate = delegate
        viewController.iokaBrowserState = iokaBrowserState
        return viewController
    }
    
    func initiateSavedCardPaymentViewController(orderAccessToken: String, card: GetCardResponse, delegate: SavedCardPaymentNavigationDelegate) -> SavedCardPaymentViewControlller {
        let vc = SavedCardPaymentViewControlller()
        vc.modalPresentationStyle = .overFullScreen
        vc.card = card
        vc.viewModel = SavedCardPaymentViewModel()
        vc.orderAccessToken = orderAccessToken
        
        return vc
    }
    
    func initiateSavedCardViewController(customerAccessToken: String?, delegate: SaveCardNavigationDelegate) -> SaveCardViewController {
        guard let customerAccessToken = customerAccessToken else { fatalError("Please provide order_access_token") }
        let viewController = SaveCardViewController()
        viewController.customerId = customerAccessToken.trimTokens()
        viewController.viewModel = SaveCardViewModel()
        return viewController
    }
}
