//
//  SaveCardCoordinator.swift
//  IOKA
//
//  Created by ablai erzhanov on 03.04.2022.
//

import UIKit


protocol SaveCardNavigationDelegate: NSObject {
    func saveCard(status: SaveCardStatus, error: IokaError?, response: GetCardResponse?)
    func completeSaveCardFlow()
}



class SaveCardCoordinator: NSObject, Coordinator {
    
    let navigationViewController: UINavigationController
    var children: [Coordinator] = []
    var childrenViewControllers: [UIViewController] = []
    let routerCoordinator: RouterCoordinator
    var url: String?
    var iokaBrowserState: IokaBrowserState?
    
    var topViewController: UIViewController!
    
    private lazy var saveCardViewController: SaveCardViewController = {
        IokaFactory.shared.initiateSavedCardViewController(customerAccessToken: IOKA.shared.customerAccessToken, delegate: self)
    }()
    
    private lazy var iokaBrowserViewController: IokaBrowserViewController = {
        guard let url = url, let iokaBrowserState = iokaBrowserState else { fatalError("Please provide action Url or IokaBrowserState") }
        return IokaFactory.shared.initiateIokaBrowserViewController(url: url, delegate: self, iokaBrowserState: iokaBrowserState)
    }()
    
    
    init(navigationViewController: UINavigationController) {
        self.navigationViewController = navigationViewController
        self.routerCoordinator = RouterNavigation(navigationViewController: navigationViewController)
        super.init()
    }
    
    func startFlow() {
        
    }
    
    func finishFlow(coordinator: Coordinator) {
        self.navigationViewController.popToViewController(topViewController, animated: true)
    }
    
    func showCardForm() {
        routerCoordinator.startFlow(saveCardViewController)
    }
    
    func dismissCardForm() {
        self.navigationViewController.viewControllers = self.navigationViewController.viewControllers.filter { $0 != saveCardViewController }
    }
    
    func show3DSecure() {
        routerCoordinator.startFlow(iokaBrowserViewController)
    }
    
    func dismiss3DSecure() {
        self.navigationViewController.viewControllers = self.navigationViewController.viewControllers.filter { $0 != iokaBrowserViewController }
    }
}

extension SaveCardCoordinator: SaveCardNavigationDelegate, IokaBrowserViewControllerDelegate {
    func completeSaveCardFlow() {
        dismissCardForm()
    }
    
    func saveCard(status: SaveCardStatus, error: IokaError?, response: GetCardResponse?) {
        if let response = response, let actionURL = response.action?.url {
            self.url = "\(actionURL)?return_url=https://ioka.kz"
            self.iokaBrowserState = .createBinding(customerId: response.customer_id, cardId: response.id)
            self.show3DSecure()
        }
    }
    
    func closeIokaBrowserViewController(_ viewController: UIViewController) {
        self.dismiss3DSecure()
    }
    
    func closeIokaBrowserViewController(_ viewController: UIViewController, iokaBrowserState: IokaBrowserState, cardPaymentResponse: CardPaymentResponse?, getCardResponse: GetCardResponse?, error: IokaError?) {
        switch iokaBrowserState {
        case .createCardPayment(_, _):
            self.dismiss3DSecure()
        case .createBinding( _, _):
            self.dismiss3DSecure()
        }
    }
}


