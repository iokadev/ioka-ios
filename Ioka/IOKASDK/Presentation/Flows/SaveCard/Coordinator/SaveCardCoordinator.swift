//
//  SaveCardCoordinator.swift
//  IOKA
//
//  Created by ablai erzhanov on 03.04.2022.
//

import UIKit
import WebKit


internal class SaveCardCoordinator: NSObject {

    
    let factory: SaveCardFlowFactory
    let navigationController: UINavigationController
    
    var saveCardViewController: SaveCardViewController?
    var threeDSecureViewController: ThreeDSecureViewController?
    
    var resultCompletion: ((FlowResult) -> Void)?
    var succeeded = false
    
    init(factory: SaveCardFlowFactory, navigationController: UINavigationController) {
        self.factory = factory
        self.navigationController = navigationController
    }
    
    func start() {
        showSaveCardFlow()
    }
    
    func showSaveCardFlow() {
        let vc = factory.makeSaveCard(delegate: self)
        self.saveCardViewController = vc
        self.navigationController.pushViewController(vc, animated: false)
    }
    
    func show3DSecure(url: URL, cardId: String) {
        let vc = factory.make3DSecure(delegate: self, url: url, cardId: cardId)
        self.threeDSecureViewController = vc
        self.navigationController.pushViewController(vc, animated: false)
    }
    
    func dismiss3DSecure() {
        self.navigationController.viewControllers = self.navigationController.viewControllers.filter { $0 != threeDSecureViewController }
        
    }
    
    func dismissSaveCard() {
        self.navigationController.viewControllers = self.navigationController.viewControllers.filter { $0 != saveCardViewController }
    }
}


extension SaveCardCoordinator: SaveCardNavigationDelegate, ThreeDSecureNavigationDelegate {
    
    func show3DSecure(_ action: Action, card: SavedCard) {
        self.show3DSecure(url: action.url, cardId: card.id)
    }
    
    
    func dismissSaveCardViewController() {
        self.dismissSaveCard()
        succeeded ? resultCompletion?(.succeeded) : resultCompletion?(.cancelled)
    }
    
    func dismissThreeDSecure() {
        self.dismiss3DSecure()
    }
    
    func dismissThreeDSecure(payment: Payment) {
        self.dismiss3DSecure()
    }
    
    func dismissThreeDSecure(apiError: APIError) {
        self.dismiss3DSecure()
        saveCardViewController?.showError(error: apiError)
        resultCompletion?(.failed(apiError))
    }
    
    func dismissThreeDSecure(error: Error) {
        self.dismiss3DSecure()
        saveCardViewController?.showError(error: error)
        resultCompletion?(.failed(error))
    }
    
    func dismissThreeDSecure(savedCard: SavedCard) {
        self.dismiss3DSecure()
        saveCardViewController?.viewModel.successCompletion?()
        succeeded = true
    }
}


