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
    var navVC: UINavigationController?
    
    
    func setUP(customerAccessToken: String, orderAccessToken: String, navigationVC: UINavigationController) {
        self.customerAccessToken = customerAccessToken
        self.orderAccessToken = orderAccessToken
        self.navVC = navigationVC
    }
    
    func getCards(customerId: String, completion: @escaping((GetCardsResponse?, CustomError?) -> Void )) {
        IokaApi.shared.getCards(customerId: customerId) { response, error in
            completion(response, error)
        }
    }
   
    
    func crateOrder() {
//        guard let orderId = orderAccessToken?.trimTokens() else { fatalError("Order id was not setted") }
//        let paymentVC = CustomFactory.shared.initiateCardPaymentViewController(order_id: orderId)
//        guard let navigationVC = navVC else { fatalError("Order id was not setted") }
//        navigationVC.pushViewController(paymentVC, animated: true)
//        let navRouter = NavigationRouter(navigationController: navigationVC)
//        let coordinator = PaymentCoordniator(router: navRouter)
//        paymentVC.onButtonPressed =  { [weak self] orderStatus, customError, response in
//            coordinator.orderStatusViewController.contentView.orderResponse = response
//            coordinator.orderStatusViewController.contentView.orderStatusState = orderStatus
//            coordinator.orderStatusViewController.contentView.error = customError
//            coordinator.present(animated: true, onDismissed: nil)
//        }
    }
}
