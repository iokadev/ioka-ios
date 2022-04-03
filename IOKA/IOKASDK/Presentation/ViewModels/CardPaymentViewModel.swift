//
//  PaymentWithCardViewModel.swift
//  IOKA
//
//  Created by ablai erzhanov on 13.03.2022.
//

import Foundation
import UIKit


class CardPaymentViewModel {
    
    var delegate: CardPaymentNavigationDelegate?
    var childViewModel = CardFormViewModel()
    var cardPaymentFailure: ((IokaError?) -> Void)?
    
    func completeCardPaymentFlow(status: PaymentResult, error: IokaError?, response: CardPaymentResponse?) {
        delegate?.completeCardPaymentFlow(status: status, error: error, response: response)
    }
    
    func completeCardPaymentFlow() {
        delegate?.completeCardPaymentFlow()
    }
    
    func createCardPayment(order_id: String, card: Card, completion: @escaping((PaymentResult, IokaError?, CardPaymentResponse?) -> Void)) {
        IokaApi.shared.createCardPayment(orderId: order_id, card: card) { [weak self] result, error in
            guard let self = self else { return }
            guard error == nil else {
                self.cardPaymentFailure?(error)
                return
            }
            guard let result = result else { return }
            
            guard result.error == nil else { completion(.paymentFailed, nil, result)
                return
            }
            
            completion(.paymentSucceed, nil, result)
            
        }
    }
    
    func getBrand(partialBin: String, completion: @escaping(GetBrandResponse?) -> Void) {
        childViewModel.getBrand(partialBin: partialBin) { result in
            completion(result)
        }
    }
    
    func getBankEmiiter(binCode: String) {
        
    }
    
    func checkPayButtonState(view: CardFormView) {
        childViewModel.checkPayButtonState(view: view)
    }
    
    func modifyPaymentTextFields(view: CardFormView, text : String, textField: UITextField) -> String {
        return childViewModel.modifyPaymentTextFields(view: view, text: text, textField: textField)
    }
    
    
}
