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
    let customBrowserState: CustomBrowserState
    
    var children: [Coordinator] = []
    let navigationViewController: UINavigationController
    
    
    private lazy var customBrowserViewController = CustomFactory.shared.initiateCustomBrowserViewController(url: url, delegate: self, customBrowserState: customBrowserState)
    
    init(parentCoordinator: IOKAMainCoordinator, url: String, customBrowserState: CustomBrowserState) {
        self.navigationViewController = parentCoordinator.navigationViewController
        self.routerCoordinator = RouterNavigation(navigationViewController: parentCoordinator.navigationViewController)
        self.parentCoordinator = parentCoordinator
        self.url = url
        self.customBrowserState = customBrowserState
        super.init()
    }
    
    func startFlow(coordinator: Coordinator) {
        routerCoordinator.startFlow(customBrowserViewController)
    }
    
    func finishFlow(coordinator: Coordinator) {
        self.navigationViewController.viewControllers = self.navigationViewController.viewControllers.filter { $0 != customBrowserViewController }
        parentCoordinator.children = parentCoordinator.children.filter { $0 != self }
    }
}

extension ThreeDSecureCoordinator: CustomBrowserViewControllerDelegate {
    func closeCustomBrowserViewController(_ viewController: UIViewController, customBrowserState: CustomBrowserState, cardPaymentResponse: CardPaymentResponse?, getCardResponse: GetCardResponse?, error: CustomError?) {
        switch customBrowserState {
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
    
    
    
    func closeCustomBrowserViewController(_ viewController: UIViewController, cardPaymentResponse: CardPaymentResponse?, error: CustomError?) {
        if let cardPaymentResponse = cardPaymentResponse, cardPaymentResponse.error == nil {
            parentCoordinator.startPaymentResultCoordinator(status: .paymentSucceed, error: nil, response: cardPaymentResponse)
        } else {
            parentCoordinator.startPaymentResultCoordinator(status: .paymentFailed, error: nil, response: cardPaymentResponse)
        }
        if let error = error {
            parentCoordinator.startPaymentResultCoordinator(status: .paymentFailed, error: error, response: nil)
        }
        finishFlow(coordinator: self)
    }
    
    
}

