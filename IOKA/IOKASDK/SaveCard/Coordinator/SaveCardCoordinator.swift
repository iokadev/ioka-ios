//
//  SaveCardCoordinator.swift
//  IOKA
//
//  Created by ablai erzhanov on 25.03.2022.
//

import UIKit


protocol SaveCardViewControllerDelegate: NSObject {
    func saveCardResult(status: SaveCardStatus, error: IokaError?, response: GetCardResponse?)
    func completeSaveCardFlow(_ viewController: SaveCardViewController)
}



class SaveCardCoordinator: NSObject, Coordinator {
    
    let routerCoordinator: RouterCoordinator
    let parentCoordinator: IOKAMainCoordinator
    var children: [Coordinator] = []
    let navigationViewController: UINavigationController
    
    private lazy var saveCardViewController: SaveCardViewController = {
        IokaFactory.shared.initiateSavedCardViewController(customerAccessToken: IOKA.shared.customerAccessToken, delegate: self)
    }()
    
    init(parentCoordinator: IOKAMainCoordinator) {
        self.routerCoordinator = RouterNavigation(navigationViewController: parentCoordinator.navigationViewController)
        self.parentCoordinator = parentCoordinator
        self.navigationViewController = parentCoordinator.navigationViewController
        super.init()
    }
    
    func startFlow(coordinator: Coordinator) {
        routerCoordinator.startFlow(saveCardViewController)
    }
    
    func finishFlow(coordinator: Coordinator) {
        self.navigationViewController.viewControllers = self.navigationViewController.viewControllers.filter { $0 != saveCardViewController }
        parentCoordinator.children = parentCoordinator.children.filter { $0 != self }
    }
}

extension SaveCardCoordinator: SaveCardViewControllerDelegate {
    func completeSaveCardFlow(_ viewController: SaveCardViewController) {
        finishFlow(coordinator: self)
    }
    
    func saveCardResult(status: SaveCardStatus, error: IokaError?, response: GetCardResponse?) {
        if let response = response, let actionURL = response.action?.url {
            parentCoordinator.startThreeDSecureCoordinator(url: "\(actionURL)?return_url=https://ioka.kz", iokaBrowserState: .createBinding(customerId: response.customer_id, cardId: response.id))
        }
    }
}
