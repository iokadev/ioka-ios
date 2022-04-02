//
//  SavedCardPaymentCoordniator.swift
//  IOKA
//
//  Created by ablai erzhanov on 25.03.2022.
//

import UIKit


protocol SavedCardPaymentNavigationDelegate: NSObject {
    func dismissView()
    func completeSavedCardPaymentFlow(status: PaymentResult, error: IokaError?, response: CardPaymentResponse?)
}



class SavedCardPaymentCoordniator: NSObject, Coordinator {
    
    let routerCoordinator: RouterCoordinator
    let parentCoordinator: IOKAMainCoordinator
    var children: [Coordinator] = []
    let navigationViewController: UINavigationController
    let card: GetCardResponse
    let orderAccessToken: String
    
    
    
    private lazy var savedCardPaymentViewControlller: SavedCardPaymentViewControlller = {
        IokaFactory.shared.initiateSavedCardPaymentViewController(orderAccessToken: orderAccessToken, card: card, delegate: self)
    }()
    
    init(parentCoordinator: IOKAMainCoordinator, card: GetCardResponse, orderAccessToken: String) {
        self.routerCoordinator = RouterNavigation(navigationViewController: parentCoordinator.navigationViewController)
        self.parentCoordinator = parentCoordinator
        self.navigationViewController = parentCoordinator.navigationViewController
        self.card = card
        self.orderAccessToken = orderAccessToken
        super.init()
        self.savedCardPaymentViewControlller.viewModel.delegate = self
    }
    
    func startFlow(coordinator: Coordinator) {
        routerCoordinator.presentViewController(savedCardPaymentViewControlller, animated: false, completion: nil)
    }
    
    func finishFlow(coordinator: Coordinator) {
        self.routerCoordinator.dismissViewController(animated: false, completion: nil)
        parentCoordinator.children = parentCoordinator.children.filter { $0 != self }
    }
}

extension SavedCardPaymentCoordniator: SavedCardPaymentNavigationDelegate {
    func dismissView() {
        self.finishFlow(coordinator: self)
    }
    
    func completeSavedCardPaymentFlow(status: PaymentResult, error: IokaError?, response: CardPaymentResponse?) {
        finishFlow(coordinator: self)
        if let response = response, let actionURL = response.action?.url {
            parentCoordinator.startThreeDSecureCoordinator(url: "\(actionURL)?return_url=https://ioka.kz", iokaBrowserState: .createCardPayment(orderId: response.order_id, paymentId: response.id))
        } else {
            parentCoordinator.startPaymentResultCoordinator(status: status, error: error, response: response)
        }
    }
    
    
}
