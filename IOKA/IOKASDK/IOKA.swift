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
        let coordinator = IOKAMainCoordinator(navigationViewController: viewController.navigationController ?? UINavigationController())
        coordinator.startPaymentCoordinator()
        coordinator.topViewController = viewController
    }
    
    func startCheckoutWithSavedCardFlow(viewController: UIViewController, orderAccessToken: String, card: GetCardResponse) {
        self.orderAccessToken = orderAccessToken
        let coordinator = IOKAMainCoordinator(navigationViewController: viewController.navigationController ?? UINavigationController())
        coordinator.startSavedCardPaymentCoordinator(card: card, orderAccessToken: orderAccessToken)
        coordinator.topViewController = viewController
    }
    
    func getCards(customerAccessToken: String, completion: @escaping(([GetCardResponse]?, IokaError?) -> Void )) {
        self.customerAccessToken = customerAccessToken
        IokaApi.shared.getCards(customerId: customerAccessToken.trimTokens()) { response, error in
            completion(response, error)
        }
    }
    
    func startSaveCardFlow(viewController: UIViewController, customerAccessToken: String) {
        self.customerAccessToken = customerAccessToken
        let coordinator = IOKAMainCoordinator(navigationViewController: viewController.navigationController ?? UINavigationController())
        coordinator.startSaveCardCoordinator()
        coordinator.topViewController = viewController
    }
}
