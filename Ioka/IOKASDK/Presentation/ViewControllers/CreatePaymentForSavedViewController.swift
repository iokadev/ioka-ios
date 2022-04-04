//
//  CreatePaymentForSavedViewController.swift
//  IOKA
//
//  Created by ablai erzhanov on 04.04.2022.
//

import UIKit


class CreatePaymentForSavedCardViewController: UIViewController {
    
    let contentView = ProgressWrapperView(state: .payment)
    var viewModel: CreatePaymentForSavedCardViewModel!
    
    override func loadView() {
        self.view = contentView
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.createPayment()
    }
}
