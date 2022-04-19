//
//  SaveCardViewModel.swift
//  IOKA
//
//  Created by ablai erzhanov on 25.03.2022.
//

import Foundation
import UIKit

internal protocol SaveCardNavigationDelegate: AnyObject {
    func saveCardDidCancel()
    func saveCardDidCloseWithSuccess()
    func saveCardDidRequireThreeDSecure(action: Action, cardSaving: CardSaving)
}


internal class SaveCardViewModel {
    
    weak var delegate: SaveCardNavigationDelegate?
    var cardFormViewModel: CardFormViewModel
    let repository: SavedCardRepository
    let customerAccessToken: AccessToken
    var errorCompletion: ((Error) -> Void)?
    var successCompletion: (() -> Void)?
    var cardBrandCompletion: ((GetBrandResponse?) -> Void)?
    
    private var isSucceeded = false
    
    init(delegate: SaveCardNavigationDelegate, repository: SavedCardRepository, customerAccessToken: AccessToken, cardFormViewModel: CardFormViewModel) {
        self.delegate = delegate
        self.repository = repository
        self.customerAccessToken = customerAccessToken
        self.cardFormViewModel = cardFormViewModel
    }
    
    func saveCard(card: CardParameters) {
        
        repository.saveCard(customerAccessToken: customerAccessToken, cardParameters: card) {[weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let cardSaving):
                switch cardSaving.status {
                case .declined(let apiError):
                    self.errorCompletion?(apiError)
                case .requiresAction(let action):
                    self.delegate?.saveCardDidRequireThreeDSecure(action: action, cardSaving: cardSaving)
                case .succeeded:
                    self.handleSuccess()
                }
            case .failure(let error):
                self.errorCompletion?(error)
            }
        }
    }
    
    func handleSuccess() {
        isSucceeded = true
        successCompletion?()
        dismissWithSuccessAfterDelay()
    }
    
    func close() {
        if isSucceeded {
            delegate?.saveCardDidCloseWithSuccess()
        } else {
            delegate?.saveCardDidCancel()
        }
    }
    
    private func dismissWithSuccessAfterDelay() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
            self?.delegate?.saveCardDidCloseWithSuccess()
        }
    }
}
