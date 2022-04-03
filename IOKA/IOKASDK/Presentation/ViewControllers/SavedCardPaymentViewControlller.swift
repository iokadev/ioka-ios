//
//  SavedCardPaymentViewControlller.swift
//  IOKA
//
//  Created by ablai erzhanov on 25.03.2022.
//

import UIKit


class SavedCardPaymentViewControlller: IokaViewController {
    
    private lazy var paymentSavedCardView = SavedCardPaymentView()
    var card: GetCardResponse!
    var orderAccessToken: String!
    var viewModel: SavedCardPaymentViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = IOKA.shared.theme.foreground
        paymentSavedCardView.delegate = self
        paymentSavedCardView.configureView(card: card)
    }
    
    override func loadView() {
        super.loadView()
        self.view = paymentSavedCardView
    }
}

extension SavedCardPaymentViewControlller: SavedCardPaymentViewDelegate {
    func dismissView(_ view: SavedCardPaymentView) {
        viewModel.dismiss()
    }
    
    func continueFlow(_ view: SavedCardPaymentView) {
        guard let text =  self.paymentSavedCardView.cvvTextField.text else { return }
        let card = Card(cardId: card.id, cvc: text)
        viewModel.createCardPayment(orderId: orderAccessToken.trimTokens(), card: card) { [weak self] status, error, result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.viewModel.completeSavedCardPaymentFlow(status: status, error: error, response: result)
            }
        }
    }
}