//
//  CardFormViewModel.swift
//  IOKA
//
//  Created by ablai erzhanov on 03.04.2022.
//

import UIKit


class CardFormViewModel {
    
    
    func getBrand(partialBin: String, completion: @escaping(GetBrandResponse?) -> Void) {
        IokaApi.shared.getBrand(partialBin: partialBin) { result, error in
            guard error == nil else {
                completion(nil)
                return
            }
            if let result = result { completion(result) }
        }
    }
    
    func getBankEmiiter(binCode: String) {
        IokaApi.shared.getEmitterByBinCode(binCode: binCode.trimEmitterBinCode()) { response, error in
//            print("DEBUG: Response is \(response)")
        }
    }
    
    func checkPayButtonState(cardNumberText: String, dateExpirationText: String, cvvText: String, completion: @escaping(IokaButtonState) -> Void) {
        
        guard checkCardNumber(cardNumberText.trimCardNumberText()) == IokaTextFieldState.correctInputData else
        {
            completion(.disabled)
            return
        }
        
        guard checkCardExpiration(dateExpirationText.trimDateExpirationText()) == IokaTextFieldState.correctInputData else
        {
            completion(.disabled)
            return
        }
        
        guard checkCVV(cvvText) == IokaTextFieldState.correctInputData else
        {
            completion(.disabled)
            return
        }
        
        completion(.enabled)
    }
    
    func checkTextFieldState(text: String, type: TextFieldType) -> IokaTextFieldState {
        switch type {
        case .cardNumber:
            return checkCardNumber(text.trimCardNumberText())
        case .cvv:
            return checkCVV(text)
        case .dateExpiration:
            return checkCardExpiration(text.trimDateExpirationText())
        }
    }
    
    
    func checkCardExpiration(_ dateExpiration: String) -> IokaTextFieldState {
        let formatter = DateFormatter()
        formatter.dateFormat = "yy-MM-dd HH:mm:ss 'UTC'"
        
        formatter.dateFormat = "yy"
        let year = Int(formatter.string(from: Date()))!
        formatter.dateFormat = "MM"
        let month = Int(formatter.string(from: Date()))!
        
        let cardDate = Array(dateExpiration)
        guard cardDate.count == 4 else { return IokaTextFieldState.wrongInputData }
        guard let cardMonth = Int("\(cardDate[0])\(cardDate[1])") else { return IokaTextFieldState.wrongInputData }
        guard let cardYear = Int("\(cardDate[2])\(cardDate[3])") else { return IokaTextFieldState.wrongInputData }
        
        if cardMonth > 12 || year > cardYear || cardYear == year && month > cardMonth {
            return IokaTextFieldState.wrongInputData
        } else {
            return IokaTextFieldState.correctInputData
        }
    }
    
    func checkCardNumber(_ cardNumber: String) -> IokaTextFieldState {
        cardNumber.count >= 15 ? IokaTextFieldState.correctInputData : IokaTextFieldState.wrongInputData
    }
    
    func checkCVV(_ cvv: String) -> IokaTextFieldState {
        cvv.count == 3 ? IokaTextFieldState.correctInputData : IokaTextFieldState.wrongInputData
    }
    
    func modifyPaymentTextFields(text : String, textFieldType: TextFieldType) -> String {
        
        switch textFieldType {
        case .cardNumber:
            return transformCardNumber(trimmedString: text.trimCardNumberText())
        case .cvv:
            return text
        case .dateExpiration:
            return transformExpirationDate(trimmedString: text.trimDateExpirationText())
        }
    }
    
    private func transformCardNumber(trimmedString: String) -> String {
        var text = ""
        let arrOfCharacters = Array(trimmedString)
        if(arrOfCharacters.count > 0) {
            for i in 0...arrOfCharacters.count-1 {
                text.append(arrOfCharacters[i])
                if((i+1) % 4 == 0 && i+1 != arrOfCharacters.count){
                    text.append(" ")
                }
            }
        }
        return text
    }
    
    private func transformExpirationDate(trimmedString: String) -> String {
        var text = ""
        let arrOfCharacters = Array(trimmedString)
        if(arrOfCharacters.count > 0) {
            for i in 0...arrOfCharacters.count-1 {
                text.append(arrOfCharacters[i])
                if((i+1) == 2 && i+1 != arrOfCharacters.count){
                    text.append("/")
                }
            }
        }
        return text
    }
}
