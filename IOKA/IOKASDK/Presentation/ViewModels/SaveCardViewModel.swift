//
//  SaveCardViewModel.swift
//  IOKA
//
//  Created by ablai erzhanov on 25.03.2022.
//

import Foundation
import UIKit


class SaveCardViewModel {
    
    var delegate: SaveCardNavigationDelegate?
    var childViewModel = CardFormViewModel()
    
    func saveCard(status: SaveCardStatus, error: IokaError?, response: GetCardResponse?) {
        delegate?.saveCard(status: status, error: error, response: response)
    }
    
    func completeSaveCardFlow() {
        delegate?.completeSaveCardFlow()
    }
    
    func saveCard(_ view: CardFormView, customerId: String, card: Card, completion: @escaping((SaveCardStatus, IokaError?, GetCardResponse?) -> Void)) {
        IokaApi.shared.createBinding(customerId: customerId, card: card) { [weak self] result, error in
            guard let self = self else { return }
            
            if let error = error {
                view.showErrorView(error: error)
                self.handleSaveButton(view: view, state: .savingFailure)
                completion(.savingFailed, error, nil)
            }
            
            
            guard let result = result else { return }
            
            if let error = result.error {
                view.showErrorView(error: error)
                self.handleSaveButton(view: view, state: .savingFailure)
                completion(.savingFailed, nil, result)
            } else {
                self.handleSaveButton(view: view, state: .savingSuccess)
                completion(.savingSucceed, nil, result)
            }
        }
    }
    
    func handleSaveButton(view: CardFormView, state: IokaButtonState) {
        DispatchQueue.main.async {
            view.endEditing(true)
            view.createButton.iokaButtonState = state
        }
    }
    
    func getBrand(partialBin: String, completion: @escaping(GetBrandResponse?) -> Void) {
        childViewModel.getBrand(partialBin: partialBin) { result in
            completion(result)
        }
    }
    
    func getBankEmiiter(binCode: String) {
        
    }
    
    func checkPayButtonState(view: CardFormView) {
        childViewModel.checkPayButtonState(view: view)
    }
    
    func modifyPaymentTextFields(view: CardFormView, text : String, textField: UITextField) -> String {
        return childViewModel.modifyPaymentTextFields(view: view, text: text, textField: textField)
    }
}