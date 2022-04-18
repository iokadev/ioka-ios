//
//  SavedCard.swift
//  Ioka
//
//  Created by Тимур Табынбаев on 14.04.2022.
//

import Foundation

public struct SavedCard {
    public let id: String
    public let maskedPAN: String
    public let expirationDate: String
    public let holder: String?
    
    let paymentSystem: String?
    let emitter: String?
    
    let cvvIsRequired: Bool
    
    public var paymentSystemIcon: UIImage? {
        guard let paymentSystem = paymentSystem else {
            return nil
        }
        
        return UIImage(named: paymentSystem, in: IokaBundle.bundle, compatibleWith: nil)
    }
    
    public var emitterIcon: UIImage? {
        guard let emitter = emitter else {
            return nil
        }
        
        return UIImage(named: emitter, in: IokaBundle.bundle, compatibleWith: nil)
    }
}
