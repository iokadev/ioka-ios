//
//  IokaLocalizable.swift
//  IOKA
//
//  Created by ablai erzhanov on 25.03.2022.
//

import Foundation

internal var locale: IokaLocale!

/// Локаль для локализации текстов в ioka SDK.
public enum IokaLocale: String {
    /// :nodoc
    case ru
    /// :nodoc
    case kk
    /// Используется системный язык
    case automatic
}

enum IokaLocalizable {
    static var saveCard: String {
        localized("saveCard")
    }
    
    static var transactionsProtected: String {
        localized("transactionProtected")
    }
    static var pay: String {
        localized("pay")
    }
    static var cvvExplained: String {
        localized("cvvExplained")
    }
    static var enterCardNumber: String {
        localized("enterCardNumber")
    }
    static var cardExpiration: String {
        localized("cardExpiration")
    }
    static var cvv: String {
        localized("cvv")
    }
    static var priceTng: String {
        localized("priceTng")
    }
    static var serverError: String {
        localized("serverError")
    }

    static var permissionCameraTitle: String {
        localized("PermissionCameraTitle")
    }
    static var permissionCameraMessage: String {
        localized("PermissionCameraMessage")
    }
    static var permissionCameraCancel: String {
        localized("PermissionCameraCancel")
    }
    static var permissionCameraAllow: String {
        localized("PermissionCameraAllow")
    }
    
    static var orderPaid: String {
        localized("orderPaid")
    }
    static var ok: String {
        localized("ok")
    }
    static var paymentFailed: String {
        localized("paymentFailed")
    }
    static var retry: String {
        localized("retry")
    }
    
    static var paymentConfirmation: String {
        localized("paymentConfirmation")
    }
    static var continueButton: String {
        localized("continueButton")
    }
    
    static var save: String {
        localized("save")
    }
    static var orderNumber: String {
        localized("orderNumber")
    }
    static var paymentProcessing: String {
        localized("paymentProcessing")
    }
    static var goPayment: String {
        localized("goPayment")
    }
    static var everythingRight: String {
        localized("everythingRight")
    }
    static var checkCardNymber: String {
        localized("checkCardNymber")
    }
    static var scanAgain: String {
        localized("scanAgain")
    }
    static var cardScanExplained: String {
        localized("cardScanExplained")
    }
    static var cardScan: String {
        localized("cardScan")
    }
    static var orPayCard: String {
        localized("orPayCard")
    }
    
    private static func localized(_ key: String) -> String {
      switch locale {
        case .automatic:
          return IokaBundle.bundle.localizedString(forKey: key, value: key, table: nil)
        default:
          let path = IokaBundle.bundle.path(forResource: locale.rawValue, ofType: "lproj")!
        let bundle = Bundle(path: path)!
        return NSLocalizedString(key, tableName: nil, bundle: bundle, value: key, comment: "")
      }
    }
    
}
