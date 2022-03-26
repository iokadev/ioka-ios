//
//  PaymentResultCoordinator.swift
//  IOKA
//
//  Created by ablai erzhanov on 14.03.2022.
//

import Foundation
import UIKit

protocol PaymentResultViewControllerDelegate: NSObject {
    func closePaymentResultViewController()
    func retryPaymentProcess()
}


class PaymentResultCoordinator: NSObject, Coordinator {
    
    
    let routerCoordinator: RouterCoordinator
    let parentCoordinator: IOKAMainCoordinator
    let orderStatus: OrderStatus
    let error: IokaError?
    let response: CardPaymentResponse?
    
    var children: [Coordinator] = []
    let navigationViewController: UINavigationController
    
    
    private lazy var paymentResultViewController = IokaFactory.shared.initiateOrderStatusViewController(orderStatus: self.orderStatus, error: self.error, response: self.response, delegate: self)
    
    init(parentCoordinator: IOKAMainCoordinator, orderStatus: OrderStatus, error: IokaError?, response: CardPaymentResponse?) {
        self.navigationViewController = parentCoordinator.navigationViewController
        self.routerCoordinator = RouterNavigation(navigationViewController: parentCoordinator.navigationViewController)
        self.parentCoordinator = parentCoordinator
        self.orderStatus = orderStatus
        self.error = error
        self.response = response
        super.init()
    }
    
    func startFlow(coordinator: Coordinator) {
        routerCoordinator.startFlow(paymentResultViewController)
    }
    
    func finishFlow(coordinator: Coordinator) {
        self.navigationViewController.viewControllers = self.navigationViewController.viewControllers.filter { $0 != paymentResultViewController }
        parentCoordinator.children = parentCoordinator.children.filter { $0 != self }
    }
}

extension PaymentResultCoordinator: PaymentResultViewControllerDelegate {
    func closePaymentResultViewController() {
        finishFlow(coordinator: self)
        parentCoordinator.finishFlow(coordinator: self)
    }

    func retryPaymentProcess() {
        finishFlow(coordinator: self)
        parentCoordinator.startPaymentCoordinator()
    }
}
