//
//  OrderConfirmationViewController.swift
//  iOKA
//
//  Created by ablai erzhanov on 12.03.2022.
//

import UIKit

class OrderConfirmationViewController: UIViewController, OrderConfirmationViewDelegate {
    
    var order: OrderModel? {
        didSet {
            orderConfirmationView.order = order
        }
    }
    let orderConfirmationView = OrderConfirmationView()
    var paymentTypeState: PaymentTypeState? {
        didSet {
            handlePaymenTypeStateChange(paymentTypeState)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        orderConfirmationView.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.view.addSubview(orderConfirmationView)
        orderConfirmationView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        self.title = "Оформление заказа"
        self.navigationController?.navigationBar.isHidden = false
    }
    
    func confirmButtonWasPressed(_ orderView: UIView) {
        if let paymentTypeState = paymentTypeState {
            guard let order = order else { return }
            DemoAppApi.shared.createOrder(price: order.orderPrice) { createOrderResponse in
                if let createOrderResponse = createOrderResponse {
                    DispatchQueue.main.async {
                        IOKA.shared.startCheckoutFlow(viewController: self, orderAccessToken: createOrderResponse.order_access_token)
                    }
                    
                }
            }
        } else {
            let vc = PaymentTypeViewController()
            DemoAppApi.shared.getProfile { result, error in
                if let result = result {
                    IOKA.shared.getCards(customerAccessToken: result.customer_access_token) { result, error in
                        if let result = result {
                            DispatchQueue.main.async {
                                vc.models = result
                                vc.delegate = self
                                self.navigationController?.pushViewController(vc, animated: true)
                            }
                            
                        }
                        if let error = error {
                            print("Cookareku epta \(error)")
                        }
                    }
                }
            }
        }
    }
    
    func handlePaymenTypeStateChange(_ state: PaymentTypeState?) {
        guard let state = state else { return }

        switch state {
        case .applePay:
            self.orderConfirmationView.paymentTypeLabel.text = "Оплатить Apple Pay"
        case .savedCard:
            self.orderConfirmationView.paymentTypeLabel.text = "Оплатить saved card"
        case .creditCard:
            self.orderConfirmationView.paymentTypeLabel.text = "Оплатить банковской картой"
        case .payWithCash:
            self.orderConfirmationView.paymentTypeLabel.text = "Оплатить cash"
        }
    }
}


extension OrderConfirmationViewController: PaymentTypeViewControllerDelegate {
    func popPaymentViewController(_ paymentTypeViewController: PaymentTypeViewController, state: PaymentTypeState) {
        self.paymentTypeState = state
    }
}
