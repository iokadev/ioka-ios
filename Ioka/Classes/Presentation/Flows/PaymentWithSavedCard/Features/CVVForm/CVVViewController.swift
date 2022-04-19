//
//  CVVViewController.swift
//  Ioka
//
//  Created by ablai erzhanov on 05.04.2022.
//

import UIKit


internal class CVVViewController: UIViewController {
    
    private lazy var contentView = CVVView()
    var card: SavedCard!
    var viewModel: CVVViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        contentView.delegate = self
        contentView.configureView(card: card)
    }
    
    override func loadView() {
        self.view = contentView
    }
}

extension CVVViewController: CVVViewDelegate {
    func closeView(_ view: CVVView) {
        viewModel.close()
    }
    
    func makePayment(_ view: CVVView) {
        guard let text = view.cvvTextField.text else { return }
        let card = CardParameters(cardId: card.id, cvc: text)
        viewModel.createPayment(cardParameters: card)
    }
}
