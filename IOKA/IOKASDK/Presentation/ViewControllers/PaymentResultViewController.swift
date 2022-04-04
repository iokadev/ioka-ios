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

protocol PaymentResultNavigationDelegate: NSObject {
    func closePaymentResultScreen()
    func retryPaymentProcess()
}

class PaymentResultViewController: IokaViewController {
    
    var paymentResult: PaymentResult?
    lazy var contentView = PaymentResultView()
    var viewModel: PaymentResultViewModel!
    let feedbackGenerator = UIImpactFeedbackGenerator(style: .heavy)
    
    override func loadView() {
        super.loadView()
        self.view = contentView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.contentView.delegate = self
        feedbackGenerator.impactOccurred()
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
