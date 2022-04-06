//
//  SaveCardViewModel.swift
//  IOKA
//
//  Created by ablai erzhanov on 25.03.2022.
//

import Foundation
import UIKit

protocol SaveCardNavigationDelegate: NSObject {
    func dismissSaveCardViewController()
    func show3DSecure(_ action: Action, card: SavedCard)
}


class SaveCardViewModel {
    
    var delegate: SaveCardNavigationDelegate?
    var childViewModel = CardFormViewModel()
    let repository: SavedCardRepository
    let customerAccessToken: AccessToken
    var errorCompletion: ((Error) -> Void)?
    var successCompletion: (() -> Void)?
    var cardBrandCompletion: ((GetBrandResponse?) -> Void)?
    
    
    init(delegate: SaveCardNavigationDelegate, repository: SavedCardRepository, customerAccessToken: AccessToken) {
        self.delegate = delegate
        self.repository = repository
        self.customerAccessToken = customerAccessToken
    }
    
    func saveCard(card: Card) {
        
        repository.saveCard(customerAccessToken: customerAccessToken, cardParameters: card) {[weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let savedCard):
                switch savedCard.status {
                case .declined(let apiError):
                    self.errorCompletion?(apiError)
                case .requiresAction(let action):
                    self.delegate?.show3DSecure(action, card: savedCard)
                case .succeeded:
                    self.successCompletion?()
                }
            case .failure(let error):
                self.errorCompletion?(error)
            }
        }
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
}
