//
//  CardPaymentViewController.swift
//  iOKA
//
//  Created by ablai erzhanov on 27.02.2022.
//

import UIKit
import Alamofire


class CardPaymentViewController: UIViewController {
    
    public var onButtonPressed: ((OrderStatus, IokaError?, CardPaymentResponse?) -> Void)?
    let contentView = CardPaymentView()
    let viewModel = PaymentWithCardViewModel()
    var order_id: String!
    var cardPaymentViewControllerDelegate: CardPaymentViewControllerDelegate?
   

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        contentView.cardPaymentViewDelegate = self
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.view.addSubview(contentView)
        self.contentView.frame = self.view.frame
    }
}

extension CardPaymentViewController: CardPaymentViewDelegate {
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
                self.cardPaymentViewControllerDelegate?.completeCardPaymentFlow(status: status, error: error, response: result)
            }
        }
    }
}
