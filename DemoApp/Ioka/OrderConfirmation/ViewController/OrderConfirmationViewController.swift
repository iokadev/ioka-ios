//
//  OrderConfirmationViewController.swift
//  iOKA
//
//  Created by ablai erzhanov on 12.03.2022.
//

import UIKit
import Ioka
import AVFoundation

internal class OrderConfirmationViewController: UIViewController {
    
    var order: OrderModel? {
        didSet {
            orderConfirmationView.order = order
        }
    }
    let orderConfirmationView = OrderConfirmationView()
    var paymentTypeState: PaymentTypeState = .empty
    let viewModel = OrderConfirmationViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Оформление заказа"
        orderConfirmationView.delegate = self
    }
    
    override func loadView() {
        self.view = orderConfirmationView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true    }
}


extension OrderConfirmationViewController: PaymentTypeViewControllerDelegate {
    func popPaymentViewController(_ paymentTypeViewController: PaymentTypeViewController, state: PaymentTypeState) {
        self.orderConfirmationView.paymentView.paymentState = state
        self.paymentTypeState = state
    }
}

extension OrderConfirmationViewController: OrderConfirmationViewDelegate {
    
    func showPaymentTypeViewController(_ view: OrderConfirmationView) {
        let vc = PaymentTypeViewController()
        vc.delegate = self
        
        viewModel.getProfile { [weak self] customerAccessToken in
            guard let self = self, let customerAccessToken = customerAccessToken else { return }
            DispatchQueue.main.async {
                vc.customerAccessToken = customerAccessToken
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    func confirmButtonWasPressed(_ orderView: OrderConfirmationView) {
        
        switch paymentTypeState {
        case .applePay:
            guard let order = order else { return }
            viewModel.createOrder(order: order) { orderAccessToken in
                Ioka.shared.applePayPaymentRequest(sourceViewController: self, orderAccessToken: orderAccessToken, applePayData: nil) { [weak self] result in
                    print("DEBUG: Result is \(result)")
                }
            }
        case .savedCard(let card):
            guard let order = order else { return }
            viewModel.createOrder(order: order) { orderAccessToken in
                Ioka.shared.startPaymentWithSavedCardFlow(sourceViewController: self, orderAccessToken: orderAccessToken, card: card) { [weak self] result in
                    if result == .succeeded {
                        self?.navigationController?.popViewController(animated: true)
                    }
                }
            }
        case .creditCard( _):
            guard let order = order else { return }
            viewModel.createOrder(order: order) { orderAccessToken in
                Ioka.shared.startPaymentFlow(sourceViewController: self, orderAccessToken: orderAccessToken, applePay: .disable) { [weak self] result in
                    if result == .succeeded {
                        self?.navigationController?.popViewController(animated: true)
                    }
                }
            }
        case .cash:
            break
        case .empty:
           showPaymentTypeViewController(orderView)
        }
    }
}
