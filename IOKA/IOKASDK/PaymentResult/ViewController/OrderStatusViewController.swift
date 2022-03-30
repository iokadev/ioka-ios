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
    let contentView = OrderStatusView()
    var paymentResultViewControllerDelegate: PaymentResultViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.contentView.delegate = self
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.view.addSubview(contentView)
        self.contentView.frame = self.view.frame
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
