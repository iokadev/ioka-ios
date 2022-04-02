//
//  CardPaymentViewController.swift
//  iOKA
//
//  Created by ablai erzhanov on 27.02.2022.
//

import UIKit

class CardPaymentViewController: IokaViewController {
    
    public var onButtonPressed: ((PaymentResult, IokaError?, CardPaymentResponse?) -> Void)?
    private lazy var contentView = CardPaymentView()
    var viewModel: CardPaymentViewModel!
    var order_id: String!
   

    override func viewDidLoad() {
        super.viewDidLoad()
        contentView.cardPaymentViewDelegate = self
    }
    
    override func loadView() {
        super.loadView()
        self.view = contentView
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
    }
}

extension CardPaymentViewController: CardPaymentViewDelegate {
    func closeCardPaymentView(_ view: CardPaymentView) {
        viewModel.completeCardPaymentFlow()
    }
    
    func getEmitterByBinCode(_ view: UIView, with binCode: String) {
        viewModel.getBankEmiiter(binCode: binCode)
    }
    
    func modifyPaymentTextFields(_ view: CardPaymentView, text: String, textField: UITextField) -> String {
        viewModel.modifyPaymentTextFields(view: view, text: text, textField: textField)
    }
    
    
    func checkPayButtonState(_ view: CardPaymentView) {
        viewModel.checkPayButtonState(view: view)
    }
    
    func getBrand(_ view: UIView, with partialBin: String) {
        viewModel.getBrand(partialBin: partialBin) { result in
            if let result = result {
                DispatchQueue.main.async {
                    self.contentView.cardNumberTextField.setCardBrandIcon(imageName: result.brand.rawValue)
                }
            }
        }
    }
    
    func createCardPayment(_ view: UIView, cardNumber: String, cvc: String, exp: String) {
        let card = Card(pan: cardNumber, exp: exp, cvc: cvc)
        viewModel.createCardPayment(order_id: order_id, card: card) { status, error, result in
            DispatchQueue.main.async {
                self.viewModel.completeCardPaymentFlow(status: status, error: error, response: result)
            }
        }
    }
}
