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
    var sourceVC: UIViewController!
    var resultHandler: ((Result<PaymentDTO, Error>) -> Void)?

    init(request: PKPaymentRequest, viewModel: ApplePayViewModel, sourceViewController: UIViewController) {
        super.init()
        self.request = request
        self.viewModel = viewModel
        self.sourceVC = sourceViewController
        self.applePayVC = PKPaymentAuthorizationViewController(paymentRequest: request)
        applePayVC?.delegate = self
        sourceViewController.present(applePayVC!, animated: false)
    }

    func start() {
//        sourceVC.navigationController?.present(applePayVC!, animated: false)
//        sourceVC.present(applePayVC!, animated: false)
    }

    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        applePayVC?.dismiss(animated: true)
    }

    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, completion: @escaping (PKPaymentAuthorizationStatus) -> Void) {
        viewModel.createPaymentToken(completion: resultHandler!)
    }

    



}
