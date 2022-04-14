//
//  SaveCardCoordinator.swift
//  IOKA
//
//  Created by ablai erzhanov on 03.04.2022.
//

import UIKit
import WebKit


internal class SaveCardCoordinator: NSObject, Coordinator {

    
    let factory: SaveCardFlowFactory
    var navigationController: UINavigationController
    
    var saveCardViewController: SaveCardViewController?
    var threeDSecureViewController: ThreeDSecureViewController?
    
    var resultCompletion: ((FlowResult) -> Void)?
    
    init(factory: SaveCardFlowFactory, navigationController: UINavigationController) {
        self.factory = factory
        self.navigationController = navigationController
    }
    
    func start() {
        showSaveCardFlow()
    }
    
    func showSaveCardFlow() {
        let vc = factory.makeSaveCard(delegate: self)
        vc.modalPresentationStyle = .overFullScreen
        self.saveCardViewController = vc
        self.navigationController.present(vc, animated: false)
    }
    
    func show3DSecure(url: URL, cardId: String) {
        let vc = factory.make3DSecure(delegate: self, url: url, cardId: cardId)
        vc.modalPresentationStyle = .overFullScreen
        self.threeDSecureViewController = vc
        self.saveCardViewController?.present(vc, animated: false)
    }
    
    func dismiss3DSecure() {
        self.saveCardViewController?.dismiss(animated: false)
        
    }
    
    func dismissSaveCard() {
        self.navigationController.dismiss(animated: false)
    }
}


extension SaveCardCoordinator: SaveCardNavigationDelegate, ThreeDSecureNavigationDelegate {
    
    func show3DSecure(_ action: Action, card: SavedCard) {
        self.show3DSecure(url: action.url, cardId: card.id)
    }
    
    
    func dismissSaveCardViewController() {
        self.dismissSaveCard()
        resultCompletion?(.cancelled)
    }
    
    func dismissSaveCardViewControllerWithSuccess() {
        self.dismissSaveCard()
        resultCompletion?(.succeeded)
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
        saveCardViewController?.viewModel.handleSuccess()
    }
}


