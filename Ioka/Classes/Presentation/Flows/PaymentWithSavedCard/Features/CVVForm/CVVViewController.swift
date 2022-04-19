//
//  CVVViewController.swift
//  Ioka
//
//  Created by ablai erzhanov on 05.04.2022.
//

import UIKit


internal class CVVViewController: UIViewController {
    
    private lazy var contentView = CVVView()
    var viewModel: CVVViewModel!
    
    override func loadView() {
        self.view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        contentView.delegate = self
        contentView.configureView(card: viewModel.card)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        contentView.cvvTextField.becomeFirstResponder()
    }
}

extension CVVViewController: CVVViewDelegate {
    func closeView(_ view: CVVView) {
        viewModel.close()
    }
    
    func makePayment(_ view: CVVView) {
        guard let text = view.cvvTextField.text else { return }
        let card = CardParameters(cardId: viewModel.card.id, cvc: text)
        viewModel.createPayment(cardParameters: card)
    }
}
