//
//  SaveCardViewController.swift
//  IOKA
//
//  Created by ablai erzhanov on 25.03.2022.
//

import UIKit

enum SaveCardStatus {
    case savingSucceed
    case savingFailed
}


class SaveCardViewController: IokaViewController {
    
    public var onButtonPressed: ((PaymentResult, IokaError?, CardPaymentResponse?) -> Void)?
    private lazy var contentView = CardFormView(state: .saving)
    var viewModel: SaveCardViewModel!
    var customerId: String!
   

    override func viewDidLoad() {
        super.viewDidLoad()
        contentView.delegate = self
    }
    
    override func loadView() {
        super.loadView()
        self.view = contentView
    }
}

extension SaveCardViewController: CardFormViewDelegate {
    func closeCardFormView(_ view: CardFormView) {
        self.viewModel.completeSaveCardFlow()
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
        
        viewModel.saveCard(view, customerId: customerId, card: card) { status, error, result in
            DispatchQueue.main.async {
                self.viewModel.saveCard(status: status, error: error, response: result)
            }
        }
    }
}
