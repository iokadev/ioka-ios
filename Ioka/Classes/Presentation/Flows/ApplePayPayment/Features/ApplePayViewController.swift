//
//  ApplePayViewController.swift
//  CreditCardValidator
//
//  Created by ablai erzhanov on 13.05.2022.
//

import UIKit
import PassKit

internal class ApplePayViewController: NSObject, PKPaymentAuthorizationViewControllerDelegate {

    var viewModel: ApplePayViewModel!
    var request: PKPaymentRequest!
    var applePayVC: PKPaymentAuthorizationViewController?

    init(request: PKPaymentRequest, viewModel: ApplePayViewModel) {
        super.init()
        self.request = request
        self.viewModel = viewModel
        self.applePayVC = PKPaymentAuthorizationViewController(paymentRequest: request)
        applePayVC?.delegate = self
    }

    
    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        viewModel.dismissApplePay()
    }

    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, completion: @escaping (PKPaymentAuthorizationStatus) -> Void) {
        viewModel.createPaymentToken()
    }
}
