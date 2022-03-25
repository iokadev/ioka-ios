//
//  PaymentSavedCardViewControlller.swift
//  IOKA
//
//  Created by ablai erzhanov on 23.03.2022.
//

import UIKit


class SavedCardPaymentViewControlller: UIViewController {
    
    let paymentSavedCardView = SavedCardPaymentView()
    var card: GetCardResponse!
    var orderAccessToken: String!
    weak var delegate: SavedCardPaymentViewControlllerDelegate?
    var viewModel = SavedCardPaymentViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = IOKA.shared.theme.fill7
        paymentSavedCardView.delegate = self
    }
    
    override func loadView() {
        super.loadView()
        self.view.addSubview(paymentSavedCardView)
        paymentSavedCardView.configureView(card: card)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.paymentSavedCardView.frame = self.view.frame
    }
}

extension SavedCardPaymentViewControlller: SavedCardPaymentViewDelegate {
    func dismissView(_ view: SavedCardPaymentView) {
        delegate?.dismissView(self)
    }
    
    func continueFlow(_ view: SavedCardPaymentView) {
        guard let text =  self.paymentSavedCardView.cvvTextField.text else { return }
        let card = Card(cardId: card.id, cvc: text)
        viewModel.createCardPayment(orderId: orderAccessToken.trimTokens(), card: card) { status, error, result in
            DispatchQueue.main.async {
                self.delegate?.completeSavedCardPaymentFlow(self, status: status, error: error, response: result)
            }
        }
    }
}
