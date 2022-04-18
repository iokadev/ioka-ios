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
    let sourceViewController: UIViewController

    lazy var navigationController: UINavigationController = {
        let controller = IokaNavigationController()
        controller.modalPresentationStyle = .overFullScreen
        
        return controller
    }()
    
    var saveCardViewController: SaveCardViewController?
    var threeDSecureViewController: ThreeDSecureViewController?
    
    var resultCompletion: ((FlowResult) -> Void)?
    
    init(factory: SaveCardFlowFactory, sourceViewController: UIViewController) {
        self.factory = factory
        self.sourceViewController = sourceViewController
    }
    
    func start() {
        showSaveCardFlow()
    }
    
    func showSaveCardFlow() {
        let vc = factory.makeSaveCard(delegate: self)
        self.saveCardViewController = vc
        self.navigationController.setViewControllers([vc], animated: false)
        self.sourceViewController.present(self.navigationController, animated: true)
    }
    
    func show3DSecure(url: URL, cardId: String) {
        let vc = factory.make3DSecure(delegate: self, url: url, cardId: cardId)
        self.threeDSecureViewController = vc
        self.navigationController.pushViewController(vc, animated: true)
    }
    
    private func dismissFlow() {
        sourceViewController.dismiss(animated: true, completion: nil)
    }
}


extension SaveCardCoordinator: SaveCardNavigationDelegate, ThreeDSecureNavigationDelegate {
    
    func show3DSecure(_ action: Action, cardSaving: CardSaving) {
        show3DSecure(url: action.url, cardId: cardSaving.id)
    }
    
    func dismissSaveCardViewController() {
        dismissFlow()
        resultCompletion?(.cancelled)
    }
    
    func dismissSaveCardViewControllerWithSuccess() {
        dismissFlow()
        resultCompletion?(.succeeded)
    }
    
    func dismissThreeDSecure() {
        dismissFlow()
        resultCompletion?(.cancelled)
    }
    
    func dismissThreeDSecure(payment: Payment) {}
    
    func dismissThreeDSecure(apiError: APIError) {
        navigationController.popViewController(animated: true)
        saveCardViewController?.showError(error: apiError)
    }
    
    func dismissThreeDSecure(error: Error) {
        navigationController.popViewController(animated: true)
        saveCardViewController?.showError(error: error)
    }
    
    func dismissThreeDSecure(cardSaving: CardSaving) {
        navigationController.popViewController(animated: true)
        saveCardViewController?.viewModel.handleSuccess()
    }
}


