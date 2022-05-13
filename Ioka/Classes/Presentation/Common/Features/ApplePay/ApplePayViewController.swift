//
//  ApplePayViewController.swift
//  CreditCardValidator
//
//  Created by ablai erzhanov on 13.05.2022.
//

import UIKit
import PassKit

internal class ApplePayViewController: PKPaymentAuthorizationViewController, PKPaymentAuthorizationViewControllerDelegate {

    var viewModel: ApplePayViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
    }

    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        self.dismiss(animated: true)
    }

    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, completion: @escaping (PKPaymentAuthorizationStatus) -> Void) {
        viewModel.createPaymentToken()
    }

    



}
