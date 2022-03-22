//
//  3DSecureCoordinator.swift
//  IOKA
//
//  Created by ablai erzhanov on 15.03.2022.
//

import Foundation
import UIKit
import WebKit


class ThreeDSecureCoordinator: NSObject, Coordinator {
    
    
    let routerCoordinator: RouterCoordinator
    let parentCoordinator: IOKAMainCoordinator
    let url: String
    let iokaBrowserState: IokaBrowserState
    
    var children: [Coordinator] = []
    let navigationViewController: UINavigationController
    
    
    private lazy var iokaBrowserViewController = IokaFactory.shared.initiateIokaBrowserViewController(url: url, delegate: self, iokaBrowserState: iokaBrowserState)
    
    init(parentCoordinator: IOKAMainCoordinator, url: String, iokaBrowserState: IokaBrowserState) {
        self.navigationViewController = parentCoordinator.navigationViewController
        self.routerCoordinator = RouterNavigation(navigationViewController: parentCoordinator.navigationViewController)
        self.parentCoordinator = parentCoordinator
        self.url = url
        self.iokaBrowserState = iokaBrowserState
        super.init()
    }
    
    func startFlow(coordinator: Coordinator) {
        routerCoordinator.startFlow(iokaBrowserViewController)
    }
    
    func finishFlow(coordinator: Coordinator) {
        self.navigationViewController.viewControllers = self.navigationViewController.viewControllers.filter { $0 != iokaBrowserViewController }
        parentCoordinator.children = parentCoordinator.children.filter { $0 != self }
    }
}

extension ThreeDSecureCoordinator: IokaBrowserViewControllerDelegate {
    func closeIokaBrowserViewController(_ viewController: UIViewController, iokaBrowserState: IokaBrowserState, cardPaymentResponse: CardPaymentResponse?, getCardResponse: GetCardResponse?, error: IokaError?) {
        switch iokaBrowserState {
        case .createCardPayment(_, _):
            if let cardPaymentResponse = cardPaymentResponse, cardPaymentResponse.error == nil {
                parentCoordinator.startPaymentResultCoordinator(status: .paymentSucceed, error: nil, response: cardPaymentResponse)
            } else {
                parentCoordinator.startPaymentResultCoordinator(status: .paymentFailed, error: nil, response: cardPaymentResponse)
            }
            if let error = error {
                parentCoordinator.startPaymentResultCoordinator(status: .paymentFailed, error: error, response: nil)
            }
        case .createBinding(let customerId, let cardId):
            print("Hello")
        }
        finishFlow(coordinator: self)
    }
}

