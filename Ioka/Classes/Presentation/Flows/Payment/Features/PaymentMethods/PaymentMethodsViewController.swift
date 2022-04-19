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
        
        viewModel.cardPaymentFailure = { [weak self] error in
            if let error = error {
                self?.showError(error)
            }
        }
    }
    
    private func setupNavigationItem() {
        setupNavigationItem(title: String(format: IokaLocalizable.priceTng, String(viewModel.order.price)),
                            closeButtonTarget: self,
                            closeButtonAction: #selector(closeButtonTapped))
    }
    
    @objc func closeButtonTapped() {
        viewModel.delegate?.paymentMethodsDidCancel()
    }
    
    func handlePayButton(state: IokaButtonState) {
        self.contentView.endEditing(true)
        self.contentView.createButton.iokaButtonState = state
        self.contentView.createButton.hideLoading(showTitle: true)
    }
    
    func showError(_ error: Error) {
        contentView.show(error: error)
        handlePayButton(state: .enabled)
        contentView.createButton.hideLoading(showTitle: true)
    }
}

extension PaymentMethodsViewController: CardFormViewDelegate {
    func closeCardFormView(_ view: CardFormView) {
        // вызывается только при сохранении
    }
    
    func createPaymentOrSaveCard(_ view: CardFormView, cardNumber: String, cvc: String, exp: String, save: Bool) {
        let card = CardParameters(pan: cardNumber, exp: exp, cvc: cvc, save: save)
        viewModel.createCardPayment(card: card)
    }
}
