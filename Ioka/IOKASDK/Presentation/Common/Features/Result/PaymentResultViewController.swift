//
//  OrderStatusViewController.swift
//  iOKA
//
//  Created by ablai erzhanov on 02.03.2022.
//

import UIKit

internal enum PaymentResult {
    case paymentSucceed
    case paymentFailed
}

internal class PaymentResultViewController: IokaViewController {
    
    lazy var contentView = PaymentResultView()
    var viewModel: PaymentResultViewModel!
    let feedbackGenerator = UIImpactFeedbackGenerator(style: .heavy)
    var error: Error?
    var order: Order?
    var paymentResult: PaymentResult!
    
    override func loadView() {
        self.view = contentView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.contentView.delegate = self
        feedbackGenerator.impactOccurred()
    }
    
    func configure(error: IokaError? = nil, order: Order? = nil) {
        if let error = error {
            contentView.configureView(error: error, paymentResult: .paymentFailed)
        } else if let order = order {
            contentView.configureView(order: order, paymentResult: .paymentSucceed)
        }
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
