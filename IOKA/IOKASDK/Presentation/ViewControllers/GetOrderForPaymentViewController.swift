//
//  GetOrderForPaymentViewController.swift
//  IOKA
//
//  Created by ablai erzhanov on 04.04.2022.
//


import UIKit


class GetOrderForPaymentViewController: UIViewController {
    
    private lazy var contentView = ProgressWrapperView(state: .order)
    var viewModel: GetOrderForPaymentViewModel!
    
    override func loadView() {
        super.loadView()
        self.view = contentView
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.getOrder()
    }
}
