//
//  OrderStatusViewController.swift
//  iOKA
//
//  Created by ablai erzhanov on 02.03.2022.
//

import UIKit

enum PaymentResult {
    case paymentSucceed
    case paymentFailed
}

class PaymentResultViewController: IokaViewController {
    
    var paymentResult: PaymentResult?
    lazy var contentView = PaymentResultView()
    var viewModel: PaymentResultViewModel!
    let feedbackGenerator = UIImpactFeedbackGenerator(style: .heavy)

    override func viewDidLoad() {
        super.viewDidLoad()
        self.contentView.delegate = self
        feedbackGenerator.impactOccurred()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.view = contentView
    }
}

extension PaymentResultViewController: PaymentResultViewDelegate {
    func tryAgain() {
        viewModel.retryPaymentProcess()
    }
    
    func closePaymentResult() {
        viewModel.closePaymentResultViewController()
    }
    
    
}
