//
//  PaymentMethodsViewController.swift
//  Ioka
//
//  Created by ablai erzhanov on 05.04.2022.
//

import UIKit

internal class PaymentMethodsViewController: UIViewController {

    private lazy var contentView = CardFormView(state: .payment(order: viewModel.order),
                                                viewModel: viewModel.cardFormViewModel)
    var viewModel: PaymentMethodsViewModel!

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

extension PaymentMethodsViewController: CardFormViewDelegate {
    func showCardScanner(_ view: CardFormView) {
        if #available(iOS 13.0, *) {
            let scannerView = CardScanner.getScanner { [weak self] number in
                self?.contentView.cardNumberTextField.text = number
                self?.contentView.didChangeText(textField: self?.contentView.cardNumberTextField ?? UITextField())
            }
            self.navigationController?.present(scannerView, animated: false)
        }
    }

    func closeCardFormView(_ view: CardFormView) {
        // вызывается только при сохранении
    }

    func createPaymentOrSaveCard(_ view: CardFormView, cardNumber: String, cvc: String, exp: String, save: Bool) {
        let card = CardParameters(pan: cardNumber, exp: exp, cvc: cvc, save: save)

        contentView.startLoading()
        viewModel.createCardPayment(card: card) { [weak self] error in
            self?.contentView.stopLoading()

            if let error = error {
                self?.show(error: error)
            }
        }
    }
}
