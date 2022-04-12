//
//  PaymentSystem.swift
//  iOKA
//
//  Created by ablai erzhanov on 02.03.2022.
//

import UIKit


public enum PaymentSystem: String, Codable {
    case VISA =  "VISA"
    case AMERICAN_EXPRESS = "AMERICAN_EXPRESS"
    case MASTERCARD = "MASTERCARD"
    case MAESTRO = "MAESTRO"
    case MIR = "MIR"
    case JCB = "JCB"
    case DINER_CLUB = "DINER_CLUB"
    case DISCOVERY = "DISCOVERY"
    case UNION_PAY = "UNION_PAY"
    case HIPER = "HIPER"
    case HIPERCARD = "HIPERCARD"
    case ELO = "ELO"
    case UNKNOWN = "UNKNOWN"
}

extension PaymentSystem {
    public static func icon(for system: String) -> UIImage? {
        let paymentSystem = PaymentSystem(rawValue: system)
        
        switch paymentSystem {
        case .VISA, .AMERICAN_EXPRESS, .DINER_CLUB, .MAESTRO, .MIR, .UNION_PAY, .MASTERCARD:
            return UIImage(named: system, in: IokaBundle.bundle, compatibleWith: nil)
        default :
            return nil
        }
    }
}
