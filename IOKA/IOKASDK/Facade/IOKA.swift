//
//  iOKA.swift
//  iOKA
//
//  Created by ablai erzhanov on 02.03.2022.
//

import Foundation
import UIKit


class IOKA: IokaThemeProtocol {
    static let shared = IOKA()
    var customerAccessToken: String?
    var orderAccessToken: String?
    var publicApiKey: String?
    var theme: IokaColors = .defaultTheme
    
    func setUp(publicApiKey: String, theme: IokaTheme = .defaultTheme) {
        self.theme = theme.iokaColors
        self.publicApiKey = publicApiKey
    }
    
    func startCheckoutFlow(viewController: UIViewController, orderAccessToken: String) {
        self.orderAccessToken = orderAccessToken
        
        let coordinator = CardPaymentCoordinator(navigationViewController: viewController.navigationController ?? UINavigationController())
        coordinator.topViewController = viewController
        coordinator.showCardPaymentForm()
    }
    
    func startCheckoutWithSavedCardFlow(viewController: UIViewController, orderAccessToken: String, card: GetCardResponse) {
        self.orderAccessToken = orderAccessToken
        let coordinator = SavedCardPaymentCoordinator(navigationViewController: viewController.navigationController ?? UINavigationController())
        coordinator.card = card
        coordinator.orderAccessToken = orderAccessToken
        coordinator.topViewController = viewController
        coordinator.startFlow()
    }
    
    func getCards(customerAccessToken: String, completion: @escaping(([GetCardResponse]?, IokaError?) -> Void )) {
        self.customerAccessToken = customerAccessToken
        IokaApi.shared.getCards(customerId: customerAccessToken.trimTokens()) { response, error in
            completion(response, error)
        }
    }
    
    func startSaveCardFlow(viewController: UIViewController, customerAccessToken: String) {
        self.customerAccessToken = customerAccessToken
        let coordinator = SaveCardCoordinator(navigationViewController: viewController.navigationController ?? UINavigationController())
        coordinator.topViewController = viewController
        coordinator.showCardForm()
    }
    
    func deleteSavedCard(customerId: String, cardId: String, completion: @escaping(IokaError?) -> Void) {
        IokaApi.shared.deleteCard(customerId: customerId, cardId: cardId) { [weak self] error in
            guard let _ = self else { return }  
            completion(error)
        }
    }
}
