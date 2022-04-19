//
//  SaveCardViewController.swift
//  IOKA
//
//  Created by ablai erzhanov on 25.03.2022.
//

import UIKit

internal class SaveCardViewController: UIViewController {
    
    var onButtonPressed: ((PaymentResult, Error?, PaymentDTO?) -> Void)?
    private lazy var contentView = CardFormView(state: .saving,
                                                viewModel: viewModel.cardFormViewModel)
    var viewModel: SaveCardViewModel!
    var customerId: String!
   

    override func viewDidLoad() {
        super.viewDidLoad()
        contentView.delegate = self
        
        setupNavigationItem()
        handleBindings()
    }
    
    override func loadView() {
        self.view = contentView
    }
    
    private func setupNavigationItem() {
        setupNavigationItem(title: IokaLocalizable.save, closeButtonTarget: self, closeButtonAction: #selector(closeButtonTapped))
    }
    
    @objc private func closeButtonTapped() {
        viewModel.close()
    }
    
    func handleBindings() {
        viewModel.errorCompletion = { [weak self] error in
            guard let self = self else { return }
            self.showError(error: error)
        }
        
        viewModel.successCompletion = { [weak self] in
            guard let self = self else { return }
            self.handleSaveButton(state: .savingSuccess)
            UINotificationFeedbackGenerator().notificationOccurred(.success)
        }
        
        viewModel.cardBrandCompletion = { [weak self] cardBrand in
            guard let self = self, let cardBrand = cardBrand else { return }
            self.contentView.cardNumberTextField.setCardBrandIcon(imageName: cardBrand.brand.rawValue)
        }
    }
    
    func showError(error: Error) {
        contentView.show(error: error)
        handleSaveButton(state: .enabled)
        contentView.createButton.hideLoading(showTitle: true)
    }
    
    func handleSaveButton(state: IokaButtonState) {
        self.contentView.endEditing(true)
        self.contentView.createButton.iokaButtonState = state
    }
}

extension SaveCardViewController: CardFormViewDelegate {
    func closeCardFormView(_ view: CardFormView) {
        self.viewModel.close()
    }
    
    func createPaymentOrSaveCard(_ view: CardFormView, cardNumber: String, cvc: String, exp: String, save: Bool) {
        let card = CardParameters(pan: cardNumber, exp: exp, cvc: cvc)
        viewModel.saveCard(card: card)
    }
}
