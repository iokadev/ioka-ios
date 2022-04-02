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
    
    public var onButtonPressed: ((OrderStatus, IokaError?, CardPaymentResponse?) -> Void)?
    private lazy var contentView = SaveCardView()
    let viewModel = SaveCardViewModel()
    var customerId: String!
    var saveCardViewControllerDelegate: SaveCardViewControllerDelegate?
   

    override func viewDidLoad() {
        super.viewDidLoad()
        contentView.saveCardViewDelegate = self
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.view = contentView
    }
}

extension SaveCardViewController: SaveCardViewDelegate {
    func close(_ view: SaveCardView) {
        self.saveCardViewControllerDelegate?.completeSaveCardFlow(self)
    }
    
    
    func getEmitterByBinCode(_ view: SaveCardView, with binCode: String) {
        viewModel.getBankEmiiter(binCode: binCode)
    }
    
    func modifyPaymentTextFields(_ view: SaveCardView, text: String, textField: UITextField) -> String {
        viewModel.modifyPaymentTextFields(view: view, text: text, textField: textField)
    }
    
    
    func checkPayButtonState(_ view: SaveCardView) {
        viewModel.checkPayButtonState(view: view)
    }
    
    func getBrand(_ view: SaveCardView, with partialBin: String) {
        viewModel.getBrand(partialBin: partialBin) { result in
            if let result = result {
                DispatchQueue.main.async {
                    self.contentView.cardNumberTextField.setCardBrandIcon(imageName: result.brand.rawValue)
                }
            }
        }
    }
    
    func createCardPayment(_ view: SaveCardView, cardNumber: String, cvc: String, exp: String) {
        let card = Card(pan: cardNumber, exp: exp, cvc: cvc)
        
        viewModel.saveCard(view, customerId: customerId, card: card) { status, error, result in
            DispatchQueue.main.async {
                self.saveCardViewControllerDelegate?.saveCardResult(status: status, error: error, response: result)
            }
        }
    }
}
