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
        viewController.viewModel.delegate = delegate
        return viewController
    }
    
    func initiatePaymentResultViewController(paymentResult: PaymentResult, error: IokaError?, response: CardPaymentResponse?, delegate: PaymentResultNavigationDelegate) -> PaymentResultViewController {
        let viewController = PaymentResultViewController()
        viewController.contentView.paymentResult = paymentResult
        viewController.contentView.error = error
        viewController.contentView.orderResponse = response
        viewController.viewModel = PaymentResultViewModel()
        viewController.viewModel.delegate = delegate
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
        vc.viewModel.delegate = delegate
        vc.orderAccessToken = orderAccessToken
        
        return vc
    }
    
    func initiateSavedCardViewController(customerAccessToken: String?, delegate: SaveCardNavigationDelegate) -> SaveCardViewController {
        guard let customerAccessToken = customerAccessToken else { fatalError("Please provide order_access_token") }
        let viewController = SaveCardViewController()
        viewController.customerId = customerAccessToken.trimTokens()
        viewController.viewModel = SaveCardViewModel()
        viewController.viewModel.delegate = delegate
        return viewController
    }
    
    func initiateErrorPopUpViewController(delegate: ErrorPopUpNavigationDelegate, error: IokaError) -> ErrorPopUpViewController{
        let vc = ErrorPopUpViewController()
        vc.viewModel = ErrorPopUpViewModel()
        vc.error = error
        vc.viewModel.delegate = delegate
        vc.modalPresentationStyle = .overFullScreen
        return vc
    }
    
    func initiateCreatePaymentForSavedCardViewModel(card: GetCardResponse, orderAccessToken: String, delegate: CreatePaymentForSavedCardNavigationDelegate) -> CreatePaymentForSavedCardViewModel {
        let viewModel = CreatePaymentForSavedCardViewModel(card: card, orderId: orderAccessToken.trimTokens(), delegate: delegate)
        return viewModel
    }
    
    func initiateProgressWrapperView(state: ProgressWrapperViewState) -> ProgressWrapperView {
        let view = ProgressWrapperView(state: state)
        return view
    }
}
