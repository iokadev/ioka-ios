//
//  ApplePayViewController.swift
//  CreditCardValidator
//
//  Created by ablai erzhanov on 13.05.2022.
//

import UIKit
import PassKit

internal class ApplePayViewController: UIViewController {

    var viewModel: ApplePayViewModel!
    var sourceViewController: UIViewController!
    private var resultsHandler: (_ applePayTokenResult: ApplePayTokenResult) -> Void?
    var request: PKPaymentRequest!

    // MARK: - Initializers
    init(resultsHandler: @escaping (_ applePayTokenResult: ApplePayTokenResult) -> Void) {
        self.resultsHandler = resultsHandler
        super.init(nibName: nil, bundle: nil)
    }

    public class func getApplePay(request: PKPaymentRequest, viewModel: ApplePayViewModel, sourceViewController: UIViewController, resultsHandler: @escaping (_ applePayTokenResult: ApplePayTokenResult) -> Void) {
        let applePayVC = ApplePayViewController(resultsHandler: resultsHandler)
        applePayVC.viewModel = viewModel
        applePayVC.request = request
        applePayVC.sourceViewController = sourceViewController
        applePayVC.modalPresentationStyle = .overFullScreen
        guard let vc = PKPaymentAuthorizationViewController(paymentRequest: request) else { return }
        vc.delegate = applePayVC

        sourceViewController.navigationController?.present(applePayVC, animated: false)
        applePayVC.present(vc, animated: false)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .clear
    }
}

extension ApplePayViewController: PKPaymentAuthorizationViewControllerDelegate {

    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        sourceViewController.dismiss(animated: false)
    }



    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, completion: @escaping (PKPaymentAuthorizationStatus) -> Void) {

        do {
            let data = payment.token.paymentData
            let paymentData = try ApplePayPaymentData(paymentData: data)

            guard let displayName = payment.token.paymentMethod.displayName, let network = payment.token.paymentMethod.network else { return }

            let paymentMethod = ApplePayPaymentMethod(displayName: displayName, network: network.rawValue, pkPaymentMethodType: payment.token.paymentMethod.type)
            let transactionId = payment.token.transactionIdentifier

            viewModel.createPaymentToken(transactionId: transactionId, paymentData: paymentData, paymentMethod: paymentMethod) { [weak self] result in
                guard let self = self else { return }
                self.handlePKPaymentAuthorizationStatus(result: result, completion: completion)
                self.sourceViewController.dismiss(animated: false) {
                    self.resultsHandler(result)
                }
            }
        } catch  {
            completion(.failure)
            sourceViewController.dismiss(animated: false)
        }
    }

    func handlePKPaymentAuthorizationStatus(result: ApplePayTokenResult, completion: @escaping (PKPaymentAuthorizationStatus) -> Void ) {
        switch result {
        case .succeed:
            completion(.success)
        case .failure( _):
            completion(.failure)
        case .applePayDidFail( _):
            completion(.failure)
        case .requiresAction( _,  _):
            completion(.success)
        }
    }
}
