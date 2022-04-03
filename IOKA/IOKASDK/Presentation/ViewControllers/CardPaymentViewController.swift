//
//  CardPaymentViewController.swift
//  iOKA
//
//  Created by ablai erzhanov on 27.02.2022.
//

import UIKit

class CardPaymentViewController: IokaViewController {
    
    private lazy var contentView = CardFormView(state: .payment)
    var viewModel: CardPaymentViewModel!
    var order_id: String!
   

    override func viewDidLoad() {
        super.viewDidLoad()
        contentView.delegate = self
        
        viewModel.cardPaymentFailure = { [weak self] error in
            if let error = error {
                self?.contentView.showErrorView(error: error)
            }
        }
    }
    
    override func loadView() {
        super.loadView()
        self.view = contentView
    }
}

extension CardPaymentViewController: CardFormViewDelegate {
    func closeCardFormView(_ view: CardFormView) {
        viewModel.completeCardPaymentFlow()
    }
    
    func getEmitterByBinCode(_ view: CardFormView, with binCode: String) {
        viewModel.getBankEmiiter(binCode: binCode)
    }
    
    func modifyPaymentTextFields(_ view: CardFormView, text: String, textField: UITextField) -> String {
        viewModel.modifyPaymentTextFields(view: view, text: text, textField: textField)
    }
    
    
    func checkCreateButtonState(_ view: CardFormView) {
        viewModel.checkPayButtonState(view: view)
    }
    
    func getBrand(_ view: CardFormView, with partialBin: String) {
        viewModel.getBrand(partialBin: partialBin) { result in
            if let result = result {
                DispatchQueue.main.async {
                    self.contentView.cardNumberTextField.setCardBrandIcon(imageName: result.brand.rawValue)
                }
            }
        }
    }
    
    func createPaymentOrSaveCard(_ view: CardFormView, cardNumber: String, cvc: String, exp: String) {
        let card = Card(pan: cardNumber, exp: exp, cvc: cvc)
        viewModel.createCardPayment(order_id: order_id, card: card) { status, error, result in
            DispatchQueue.main.async {
                self.viewModel.completeCardPaymentFlow(status: status, error: error, response: result)
            }
        }
    }
}
