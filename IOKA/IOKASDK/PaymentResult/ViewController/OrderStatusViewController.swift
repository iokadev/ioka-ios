//
//  OrderStatusViewController.swift
//  iOKA
//
//  Created by ablai erzhanov on 02.03.2022.
//

import UIKit

enum OrderStatus {
    case paymentSucceed
    case paymentFailed
}

class OrderStatusViewController: IokaViewController {
    
    var orderStatus: OrderStatus?
    private lazy var contentView = OrderStatusView()
    var paymentResultViewControllerDelegate: PaymentResultViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.contentView.delegate = self
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.view = contentView
    }
}

extension OrderStatusViewController: OrderStatusViewDelegate {
    func tryAgain() {
        self.paymentResultViewControllerDelegate?.retryPaymentProcess()
    }
    
    func closePaymentResult() {
        self.paymentResultViewControllerDelegate?.closePaymentResultViewController()
    }
    
    
}
