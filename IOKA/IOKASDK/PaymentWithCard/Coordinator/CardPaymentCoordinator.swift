//
//  CardPaymentCoordinator.swift
//  IOKA
//
//  Created by ablai erzhanov on 14.03.2022.
//

import Foundation
import UIKit


protocol CardPaymentViewControllerDelegate: NSObject {
    func completeCardPaymentFlow(status: OrderStatus, error: IokaError?, response: CardPaymentResponse?)
}



class CardPaymentCoordinator: NSObject, Coordinator {
    
    let routerCoordinator: RouterCoordinator
    let parentCoordinator: IOKAMainCoordinator
    var children: [Coordinator] = []
    let navigationViewController: UINavigationController
    
    
    
    private lazy var cardPaymentViewController: CardPaymentViewController = {
        IokaFactory.shared.initiateCardPaymentViewController(orderAccesToken: IOKA.shared.orderAccessToken, delegate: self)
    }()
    
    init(parentCoordinator: IOKAMainCoordinator) {
        self.routerCoordinator = RouterNavigation(navigationViewController: parentCoordinator.navigationViewController)
        self.parentCoordinator = parentCoordinator
        self.navigationViewController = parentCoordinator.navigationViewController
        super.init()
    }
    
    func startFlow(coordinator: Coordinator) {
        routerCoordinator.startFlow(cardPaymentViewController)
    }
    
    func finishFlow(coordinator: Coordinator) {
        self.navigationViewController.viewControllers = self.navigationViewController.viewControllers.filter { $0 != cardPaymentViewController }
        parentCoordinator.children = parentCoordinator.children.filter { $0 != self }
    }
}

extension CardPaymentCoordinator: CardPaymentViewControllerDelegate {
    func completeCardPaymentFlow(status: OrderStatus, error: IokaError?, response: CardPaymentResponse?) {
        if let response = response, let actionURL = response.action?.url {
            parentCoordinator.startThreeDSecureCoordinator(url: "\(actionURL)?return_url=https://ioka.kz", iokaBrowserState: .createCardPayment(orderId: response.order_id, paymentId: response.id))
        } else {
            parentCoordinator.startPaymentResultCoordinator(status: status, error: error, response: response)
        }
        finishFlow(coordinator: self)
    }
}
