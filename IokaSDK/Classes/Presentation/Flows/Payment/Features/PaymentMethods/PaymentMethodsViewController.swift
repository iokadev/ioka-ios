//
//  PaymentMethodsViewController.swift
//  Ioka
//
//  Created by ablai erzhanov on 05.04.2022.
//

import UIKit
import AVFoundation

internal class PaymentMethodsViewController: UIViewController {

    var viewModel: PaymentMethodsViewModel!
    private lazy var contentView = PaymentMethodsView(order: viewModel.order, viewModel: viewModel.cardFormViewModel, hasApplePay: viewModel.hasApplePay)

    override func loadView() {
        self.view = contentView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        contentView.delegate = self
        setupNavigationItem()
    }

    private func setupNavigationItem() {
        setupNavigationItem(title: String(format: IokaLocalizable.priceTng, String(viewModel.order.price)),
                            closeButtonTarget: self,
                            closeButtonAction: #selector(closeButtonTapped))
    }

    @objc func closeButtonTapped() {
        viewModel.delegate?.paymentMethodsDidCancel()
    }

    func show(error: Error) {
        contentView.show(error: error)
    }
}

extension PaymentMethodsViewController:  PaymentMethodsViewDelegate {
    func paymentMethodsView(createPayment paymentMethodsView: PaymentMethodsView, cardNumber: String, cvc: String, exp: String, save: Bool) {
        let card = CardParameters(pan: cardNumber, exp: exp, cvc: cvc, save: save)

        contentView.startLoading()
        viewModel.createCardPayment(card: card) { [weak self] error in
            self?.contentView.stopLoading()

            if let error = error {
                self?.show(error: error)
            }
        }
    }

    func paymentMethodsView(showCardScanner paymentMethodsView: PaymentMethodsView) {
        AVCaptureDevice.requestAccess(for: AVMediaType.video) { [weak self] response in
            guard let self = self else { return }
            DispatchQueue.main.async {
                if response {
                    self.showScanner()
                } else {
                    self.alertCameraAccessNeeded()
                }
            }
        }
    }

    func paymentMethodsView(closePaymentMethodsView paymentMethodsView: PaymentMethodsView) {
        // вызывается только при сохранении
    }

    func paymentMethodsView(applePayButtonDidPressed paymentMethodsView: PaymentMethodsView) {
        Ioka.shared.startApplePayFlowFromSDK(sourceViewController: self, orderAccessToken: viewModel.orderAccessToken, order: viewModel.order, applePayData: viewModel.applePayData) { [weak self] applePayTokenResult in
            guard let self = self else { return }
            self.viewModel.handleApplePayResult(result: applePayTokenResult) { error in
                if let error = error {
                    self.show(error: error)
                }
            }
        }
    }

    private func showScanner() {
        if #available(iOS 13.0, *) {
            let scannerView = CardScanner.getScanner { [weak self] number in
                self?.contentView.cardFormView.cardNumberTextField.text = number
                self?.contentView.cardFormView.didChangeText(textField: self?.contentView.cardFormView.cardNumberTextField ?? UITextField())
            }
            self.navigationController?.present(scannerView, animated: false)
        }
    }

    private func alertCameraAccessNeeded() {
        let settingsAppURL = URL(string: UIApplication.openSettingsURLString)!

        let alert = UIAlertController(
            title: IokaLocalizable.permissionCameraTitle,
            message: IokaLocalizable.permissionCameraMessage,
            preferredStyle: UIAlertController.Style.alert
        )

        alert.addAction(UIAlertAction(title: IokaLocalizable.permissionCameraCancel, style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: IokaLocalizable.permissionCameraAllow, style: .cancel, handler: { (alert) -> Void in
            UIApplication.shared.open(settingsAppURL, options: [:], completionHandler: nil)
        }))

        self.navigationController?.present(alert, animated: true, completion: nil)
    }
}
