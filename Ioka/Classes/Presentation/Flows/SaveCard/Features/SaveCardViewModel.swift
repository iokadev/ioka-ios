//
//  SaveCardViewModel.swift
//  IOKA
//
//  Created by ablai erzhanov on 25.03.2022.
//

import Foundation
import UIKit

internal protocol SaveCardNavigationDelegate: NSObject {
    func dismissSaveCardViewController()
    func dismissSaveCardViewControllerWithSuccess()
    func show3DSecure(_ action: Action, cardSaving: CardSaving)
}


internal class SaveCardViewModel {
    
    var delegate: SaveCardNavigationDelegate?
    var childViewModel: CardFormViewModel
    let repository: SavedCardRepository
    let customerAccessToken: AccessToken
    var errorCompletion: ((Error) -> Void)?
    var successCompletion: (() -> Void)?
    var cardBrandCompletion: ((GetBrandResponse?) -> Void)?
    
    private var isSucceeded = false
    
    init(delegate: SaveCardNavigationDelegate, repository: SavedCardRepository, customerAccessToken: AccessToken) {
        self.delegate = delegate
        self.repository = repository
        self.customerAccessToken = customerAccessToken
        self.childViewModel = CardFormViewModel(api: repository.api)
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
                    self.delegate?.show3DSecure(action, cardSaving: cardSaving)
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
    
    func getBrand(partialBin: String) {
        
        repository.api.getBrand(partialBin: partialBin) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let brand):
                self.cardBrandCompletion?(brand)
            case .failure( _):
                self.cardBrandCompletion?(nil)
            }
        }
    }
    
    func getBankEmiiter(binCode: String) {
        
    }
    
    func checkCreateButtonState(cardNumberText: String, dateExpirationText: String, cvvText: String, completion: @escaping(IokaButtonState) -> Void) {
        
        childViewModel.checkPayButtonState(cardNumberText: cardNumberText, dateExpirationText: dateExpirationText, cvvText: cvvText) { [weak self] buttonState in
            guard let _ = self else { return }
            completion(buttonState)
        }
    }
    
    func checkTextFieldState(text: String, type: TextFieldType) -> IokaTextFieldState {
        childViewModel.checkTextFieldState(text: text, type: type)
    }
    
    func modifyPaymentTextFields(text : String, textFieldType: TextFieldType) -> String {
        return childViewModel.modifyPaymentTextFields(text: text, textFieldType: textFieldType)
    }
    
    func close() {
        if isSucceeded {
            delegate?.dismissSaveCardViewControllerWithSuccess()
        } else {
            delegate?.dismissSaveCardViewController()
        }
    }
    
    private func dismissWithSuccessAfterDelay() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
            self?.delegate?.dismissSaveCardViewControllerWithSuccess()
        }
    }
}
