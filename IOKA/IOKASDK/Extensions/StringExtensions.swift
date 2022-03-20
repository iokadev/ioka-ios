//
//  StringExtensions.swift
//  iOKA
//
//  Created by ablai erzhanov on 28.02.2022.
//

import Foundation


extension String {
    
    func transformCardNumber(trimmedString: String) -> String {
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
    
    func transformExpirationDate(trimmedString: String) -> String {
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
    
    func trimCardNumberText() -> String {
        self.components(separatedBy: .whitespaces).joined()
    }
    
    func trimDateExpirationText() -> String {
        self.components(separatedBy: "/").joined()
    }
    
    func checkCardExpiration() -> CustomTextFieldState {
        let formatter = DateFormatter()
        formatter.dateFormat = "yy-MM-dd HH:mm:ss 'UTC'"
        
        formatter.dateFormat = "yy"
        let year = Int(formatter.string(from: Date()))!
        formatter.dateFormat = "MM"
        let month = Int(formatter.string(from: Date()))!
        
        let cardDate = Array(self)
        guard cardDate.count == 4 else { return CustomTextFieldState.wrongInputData }
        guard let cardMonth = Int("\(cardDate[0])\(cardDate[1])") else { return CustomTextFieldState.wrongInputData }
        guard let cardYear = Int("\(cardDate[2])\(cardDate[3])") else { return CustomTextFieldState.wrongInputData }
        
        if cardMonth > 12 || year > cardYear || cardYear == year && month > cardMonth {
            return CustomTextFieldState.wrongInputData
        } else {
            return CustomTextFieldState.correctInputData
        }
    }
    
    func checkCardNumber() -> CustomTextFieldState {
        self.count == 16 ? CustomTextFieldState.correctInputData : CustomTextFieldState.wrongInputData
    }
    
    func checkCVV() -> CustomTextFieldState {
        self.count == 3 ? CustomTextFieldState.correctInputData : CustomTextFieldState.wrongInputData
    }
    
    
    func trimTokens() -> String {
        var text = self
        if let dotRange = text.range(of: "_secret") {
            text.removeSubrange(dotRange.lowerBound..<text.endIndex)
            return text
        } else {
            return text
        }
    }
    
    func trimEmitterBinCode() -> String {
        let trimmedText = self.components(separatedBy: .whitespaces).joined()
        let mySubstring = String(trimmedText.prefix(5))
        return mySubstring
    }
}