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
    
    func showThreeDSecure(action: Action, cardId: String) {
        let vc = factory.makeThreeDSecure(delegate: self, action: action, cardId: cardId)
        self.threeDSecureViewController = vc
        self.navigationController.pushViewController(vc, animated: true)
    }
    
    private func dismissFlow(result: FlowResult) {
        sourceViewController.dismiss(animated: true) {
            self.resultCompletion?(result)
        }
    }
}


extension SaveCardCoordinator: SaveCardNavigationDelegate, ThreeDSecureNavigationDelegate {
    func saveCardDidCancel() {
        dismissFlow(result: .cancelled)
    }
    
    func saveCardDidCloseWithSuccess() {
        dismissFlow(result: .succeeded)
    }
    
    func saveCardDidRequireThreeDSecure(action: Action, cardSaving: CardSaving) {
        showThreeDSecure(action: action, cardId: cardSaving.id)
    }
    
    func threeDSecureDidSucceed() {
        navigationController.popViewController(animated: true)
        saveCardViewController?.showSuccess()
    }
    
    func threeDSecureDidFail(declinedError: Error) {
        navigationController.popViewController(animated: true)
        saveCardViewController?.show(error: declinedError)
    }
    
    func threeDSecureDidFail(otherError: Error) {
        navigationController.popViewController(animated: true)
        saveCardViewController?.show(error: otherError)
    }
    
    func threeDSecureDidCancel() {
        dismissFlow(result: .cancelled)
    }
}


