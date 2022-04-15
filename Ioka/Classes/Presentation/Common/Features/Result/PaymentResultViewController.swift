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

internal class PaymentResultViewController: UIViewController {
    
    lazy var contentView = PaymentResultView()
    var viewModel: PaymentResultViewModel!
    var error: Error?
    var order: Order?
    var theme: IokaTheme!
    var paymentResult: PaymentResult!
    
    override func loadView() {
        self.view = contentView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.contentView.delegate = self
    }
    
    func configure(error: Error? = nil, order: Order? = nil) {
        let feedbackGenerator = UINotificationFeedbackGenerator()
        
        if let error = error {
            feedbackGenerator.notificationOccurred(.error)
            contentView.configureView(error: error, paymentResult: .paymentFailed)
        } else if let order = order {
            feedbackGenerator.notificationOccurred(.success)
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
