//
//  StringExtensions.swift
//  iOKA
//
//  Created by ablai erzhanov on 28.02.2022.
//

import Foundation


internal extension String {
    
    func trimCardNumberText() -> String {
        self.components(separatedBy: .whitespaces).joined()
    }
    
    func trimDateExpirationText() -> String {
        self.components(separatedBy: "/").joined()
    }
        
    func trimEmitterBinCode() -> String {
        let trimmedText = self.components(separatedBy: .whitespaces).joined()
        let mySubstring = String(trimmedText.prefix(5))
        return mySubstring
    }
    
    func trimPanMasked() -> String {
        let trimmedPanNumber = String(self.suffix(8))
        return trimmedPanNumber
    }
}
