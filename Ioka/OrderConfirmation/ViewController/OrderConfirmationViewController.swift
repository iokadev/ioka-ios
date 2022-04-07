//
//  OrderConfirmationViewController.swift
//  iOKA
//
//  Created by ablai erzhanov on 12.03.2022.
//

import UIKit

class OrderConfirmationViewController: UIViewController {
    
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
        orderConfirmationView.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.view.addSubview(orderConfirmationView)
        orderConfirmationView.frame = self.view.frame
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        self.title = "Оформление заказа"
        self.navigationController?.navigationBar.isHidden = false
    }
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
        case .applePay(let title):
            print(title)
        case .savedCard(let card):
            guard let order = order else { return }
            viewModel.createOrder(order: order) { orderAccessToken in
                Ioka.shared.startCheckoutWithSavedCardFlow(viewController: self, orderAccessToken: orderAccessToken, card: card)
            }
        case .creditCard( _):
            guard let order = order else { return }
            viewModel.createOrder(order: order) { orderAccessToken in
                Ioka.shared.startCheckoutFlow(viewController: self, orderAccessToken: orderAccessToken)
            }
        case .cash(let title):
            print(title)
        case .empty:
           showPaymentTypeViewController(orderView)
        }
    }
}
