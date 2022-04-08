//
//  CVVViewController.swift
//  Ioka
//
//  Created by ablai erzhanov on 05.04.2022.
//

import UIKit


class CVVViewController: IokaViewController {
    
    private lazy var contentView = CVVView()
    var card: GetCardResponse!
    var viewModel: CVVViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = colors.foreground
        contentView.delegate = self
        contentView.configureView(card: card)
    }
    
    override func loadView() {
        self.view = contentView
    }
}

extension CVVViewController: CVVViewDelegate {
    func closeView(_ view: CVVView) {
        viewModel.delegate?.dismissCVVForm()
    }
    
    func makePayment(_ view: CVVView) {
        guard let text = view.cvvTextField.text else { return }
        let card = Card(cardId: card.id, cvc: text)
        viewModel.createPayment(cardParameters: card)
    }
}
