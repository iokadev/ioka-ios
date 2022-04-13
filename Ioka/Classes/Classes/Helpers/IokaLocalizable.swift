//
//  IokaLocalizable.swift
//  IOKA
//
//  Created by ablai erzhanov on 25.03.2022.
//

import Foundation

public var locale: IokaLocale = Ioka.shared.locale

public enum IokaLocale: String {
  case ru
  case kk
  case automatic
}

enum IokaLocalizable {
    static var saveCard = localized("saveCard")
    static var transactionsProtected = localized("transactionProtected")
    static var pay = localized("pay")
    static var enterCardNumber = localized("enterCardNumber")
    static var cardExpiration = localized("cardExpiration")
    static var cvv = localized("cvv")
    static var priceTng = localized("priceTng")
    static var serverError = localized("serverError")
    
    
    static var orderPaid = localized("orderPaid")
    static var ok = localized("ok")
    static var paymentFailed = localized("paymentFailed")
    static var retry = localized("retry")
    
    static var paymentConfirmation = localized("paymentConfirmation")
    static var continueButton = localized("continueButton")
    
    static var save = localized("save")
    static var orderNumber = localized("orderNumber")
    static var paymentProcessing = localized("paymentProcessing")
    static var goPayment = localized("goPayment")
    
    private static func localized(_ key: String) -> String {
      switch locale {
        case .automatic:
        return NSLocalizedString(key, comment: "")
        default:
          let path = Bundle.main.path(forResource: locale.rawValue, ofType: "lproj")!
        let bundle = Bundle(path: path)!
        return NSLocalizedString(key, tableName: nil, bundle: bundle, value: "", comment: "")
      }
    }
    
}
