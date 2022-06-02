//
//  SaveCardViewController.swift
//  IOKA
//
//  Created by ablai erzhanov on 25.03.2022.
//

import UIKit

internal class SaveCardViewController: UIViewController {

    var onButtonPressed: ((PaymentResult, Error?, PaymentDTO?) -> Void)?
    private lazy var contentView = SaveCardView(viewModel: viewModel.cardFormViewModel)
    var viewModel: SaveCardViewModel!
    var customerId: String!


    override func viewDidLoad() {
        super.viewDidLoad()
        contentView.delegate = self

        setupNavigationItem()
    }

    override func loadView() {
        self.view = contentView
    }

    func showSuccess() {
        contentView.showSavingSuccess()
        viewModel.handleSuccess()
    }

    func show(error: Error) {
        contentView.stopLoading()
        contentView.show(error: error)
    }

    private func setupNavigationItem() {
        setupNavigationItem(title: IokaLocalizable.save, closeButtonTarget: self, closeButtonAction: #selector(closeButtonTapped))
    }

    @objc private func closeButtonTapped() {
        viewModel.close()
    }
}

extension SaveCardViewController: SaveCardViewDelegate {

    func saveCardView(saveCard saveCardView: SaveCardView, cardNumber: String, cvc: String, exp: String, save: Bool) {
        let card = CardParameters(pan: cardNumber, exp: exp, cvc: cvc)

        contentView.startLoading()
        viewModel.saveCard(card: card) { [weak self] result in
            switch result {
            case .none:
                self?.contentView.stopLoading()
            case .success:
                self?.showSuccess()
            case .failure(let error):
                self?.show(error: error)
            }
        }
    }

    func saveCardView(showCardScanner saveCardView: SaveCardView) {
        if #available(iOS 13.0, *) {
            let scannerView = CardScanner.getScanner { [weak self] number in
                self?.contentView.cardFormView.cardNumberTextField.text = number
                self?.contentView.cardFormView.didChangeText(textField: self?.contentView.cardFormView.cardNumberTextField ?? UITextField())
            }
            self.navigationController?.present(scannerView, animated: false)
        }
    }

    func saveCardView(closeSaveCardView saveCardView: SaveCardView) {
        self.viewModel.close()
    }
}
