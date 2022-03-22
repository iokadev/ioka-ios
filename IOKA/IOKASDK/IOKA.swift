//
//  iOKA.swift
//  iOKA
//
//  Created by ablai erzhanov on 02.03.2022.
//

import Foundation
import UIKit


class IOKA {
    static let shared = IOKA()
    var customerAccessToken: String?
    var orderAccessToken: String?
    var publicApiKey: String?
    
    func setUP(publicApiKey: String) {
        self.publicApiKey = publicApiKey
    }
    
    func startCheckoutFlow(viewController: UIViewController, orderAccessToken: String) {
        self.orderAccessToken = orderAccessToken
        let coordinator = IOKAMainCoordinator(navigationViewController: viewController.navigationController ?? UINavigationController())
        coordinator.startPaymentCoordinator()
        coordinator.topViewController = viewController
    }
    
    func getCards(customerAccessToken: String, completion: @escaping(([GetCardResponse]?, CustomError?) -> Void )) {
        self.customerAccessToken = customerAccessToken
        IokaApi.shared.getCards(customerId: customerAccessToken.trimTokens()) { response, error in
            completion(response, error)
        }
    }
}
