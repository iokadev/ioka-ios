//
//  IOKAMainCoordinator.swift
//  IOKA
//
//  Created by ablai erzhanov on 14.03.2022.
//

import Foundation
import UIKit


protocol Coordinator: NSObject {
    var children: [Coordinator] { get }
    var navigationViewController: UINavigationController { get }
    func startFlow(coordinator: Coordinator)
    func finishFlow(coordinator: Coordinator)
}


class IOKAMainCoordinator: NSObject, Coordinator {
    
    let navigationViewController: UINavigationController
    var children: [Coordinator] = []
    
    var topViewController: UIViewController!
    
    init(navigationViewController: UINavigationController) {
        self.navigationViewController = navigationViewController
        super.init()
    }
    
    func startFlow(coordinator: Coordinator) {
        self.children.append(coordinator)
    }
    
    func finishFlow(coordinator: Coordinator) {
        self.navigationViewController.popToViewController(topViewController, animated: true)
    }
    
    
    func startPaymentCoordinator() {
        let paymentCoordinator = CardPaymentCoordinator(parentCoordinator: self)
        self.children.append(paymentCoordinator)
        paymentCoordinator.startFlow(coordinator: self)
    }
    
    func startPaymentResultCoordinator(status: PaymentResult, error: IokaError?, response: CardPaymentResponse?) {
        let paymentResultCoordninator = PaymentResultCoordinator(parentCoordinator: self, paymentResult: status, error: error, response: response)
        self.children.append(paymentResultCoordninator)
        paymentResultCoordninator.startFlow(coordinator: self)
    }
    
    func startThreeDSecureCoordinator(url: String, iokaBrowserState: IokaBrowserState) {
        let paymentResultCoordninator = ThreeDSecureCoordinator(parentCoordinator: self, url: url, iokaBrowserState: iokaBrowserState)
        self.children.append(paymentResultCoordninator)
        paymentResultCoordninator.startFlow(coordinator: self)
    }
    
    func startSavedCardPaymentCoordinator(card: GetCardResponse, orderAccessToken: String) {
        let savedCardPaymentCoordinator = SavedCardPaymentCoordniator(parentCoordinator: self, card: card, orderAccessToken: orderAccessToken)
        self.children.append(savedCardPaymentCoordinator)
        savedCardPaymentCoordinator.startFlow(coordinator: self)
    }
    
    func startSaveCardCoordinator() {
        let saveCardCoordinator = SaveCardCoordinator(parentCoordinator: self)
        self.children.append(saveCardCoordinator)
        saveCardCoordinator.startFlow(coordinator: self)
    }
}
