//
//  Factory.swift
//  iOKA
//
//  Created by ablai erzhanov on 09.03.2022.
//

import Foundation


class CustomFactory {
    static let shared = CustomFactory()
    
    func initiateCardPaymentViewController(orderAccesToken: String?, delegate: CardPaymentViewControllerDelegate) -> CardPaymentViewController {
        guard let orderAccesToken = orderAccesToken else { fatalError("Please provide order_access_token") }
        let viewController = CardPaymentViewController()
        viewController.order_id = orderAccesToken.trimTokens()
        viewController.cardPaymentViewControllerDelegate = delegate
        return viewController
    }
    
    func initiateOrderStatusViewController(orderStatus: OrderStatus, error: CustomError?, response: CardPaymentResponse?, delegate: PaymentResultViewControllerDelegate) -> OrderStatusViewController {
        let viewController = OrderStatusViewController()
        viewController.contentView.orderStatusState = orderStatus
        viewController.contentView.error = error
        viewController.contentView.orderResponse = response
        viewController.paymentResultViewControllerDelegate = delegate
        return viewController
    }
    
    func initiateCustomBrowserViewController(url: String, delegate: CustomBrowserViewControllerDelegate, customBrowserState: CustomBrowserState) -> CustomBrowserViewController {
        let viewController = CustomBrowserViewController()
        viewController.url = URL(string: url)!
        viewController.delegate = delegate
        viewController.customBrowserState = customBrowserState
        return viewController
    }
}
