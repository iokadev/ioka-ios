//
//  CardFormViewModel.swift
//  IOKA
//
//  Created by ablai erzhanov on 03.04.2022.
//

import UIKit
import CreditCardValidator

enum ValidationState {
    case invalid, valid
}

internal class CardFormViewModel {
    let repository: CardInfoRepository
    
    var isEmitterSetted: Bool = false
    
    init(repository: CardInfoRepository) {
        self.repository = repository
    }
    
    func getPaymentSystem(partialBin: String, completion: @escaping(String?) -> Void) {
        
        if let type = CreditCardValidator(partialBin).type {
            switch type {
            case .amex:
                completion(PaymentSystem.AMERICAN_EXPRESS.rawValue)
            case .visa:
                completion(PaymentSystem.VISA.rawValue)
            case .masterCard:
                completion(PaymentSystem.MASTERCARD.rawValue)
            case .maestro:
                completion(PaymentSystem.MAESTRO.rawValue)
            case .dinersClub:
                completion(PaymentSystem.DINER_CLUB.rawValue)
            case .jcb:
                completion(PaymentSystem.JCB.rawValue)
            case .discover:
                completion(PaymentSystem.DISCOVERY.rawValue)
            case .unionPay:
                completion(PaymentSystem.UNION_PAY.rawValue)
            case .mir:
                completion(PaymentSystem.MIR.rawValue)
            }
        } else {
            repository.getPaymentSystem(partialBin: partialBin.trimCardNumberText()) { result in
                completion(try? result.get())
            }
        }
    }
    
    func getEmitterByBinCode(binCode: String, completion: @escaping(EmitterDTO?) -> Void) {
        if binCode.count >= 6 {
            guard isEmitterSetted == false else { return }
            repository.getEmitter(bin: binCode.trimEmitterBinCode()) { result in
                completion(try? result.get())
            }
        } else {
            isEmitterSetted = false
        }
    }
    
    func checkPayButtonState(cardNumberText: String, dateExpirationText: String, cvvText: String) -> IokaButton.State {
        guard checkCardNumber(cardNumberText) == .valid,
              checkCardExpiration(dateExpirationText) == .valid,
              checkCVV(cvvText) == .valid else {
                  return .disabled
              }
        
        return .enabled
    }
    
    func checkCardExpiration(_ dateExpiration: String) -> ValidationState {
        let expiration = dateExpiration.trimDateExpirationText()
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yy-MM-dd HH:mm:ss 'UTC'"
        
        formatter.dateFormat = "yy"
        let year = Int(formatter.string(from: Date()))!
        formatter.dateFormat = "MM"
        let month = Int(formatter.string(from: Date()))!
        
        let cardDate = Array(expiration)
        guard cardDate.count == 4 else { return .invalid }
        guard let cardMonth = Int("\(cardDate[0])\(cardDate[1])") else { return .invalid }
        guard let cardYear = Int("\(cardDate[2])\(cardDate[3])") else { return .invalid }
        
        if cardMonth > 12 || year > cardYear || cardYear == year && month > cardMonth {
            return .invalid
        } else {
            return .valid
        }
    }
    
    func checkCardNumber(_ cardNumber: String) -> ValidationState {
        if CreditCardValidator(cardNumber).isValid {
            return .valid
        } else {
            let number = cardNumber.trimCardNumberText()
            return number.count >= 15 ? .valid : .invalid
        }
    }
    
    func checkCVV(_ cvv: String) -> ValidationState {
        cvv.count == 3 ? .valid : .invalid
    }
    
    func transformCardNumber(_ cardNumber: String) -> String {
        let number = cardNumber.trimCardNumberText()
        var text = ""
        let arrOfCharacters = Array(number)
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
    
    func transformExpirationDate(_ expirationDate: String) -> String {
        let expiration = expirationDate.trimDateExpirationText()
        
        var text = ""
        let arrOfCharacters = Array(expiration)
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
