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
        guard let order = order else { return }

        DemoAppApi.shared.createOrder(price: order.orderPrice) { createOrderResponse in
            if let createOrderResponse = createOrderResponse {
                DispatchQueue.main.async {
                    IOKA.shared.setUP(customerAccessToken: createOrderResponse.customer_access_token, orderAccessToken: createOrderResponse.order_access_token, navigationVC: self.navigationController ?? UINavigationController())
                    let coordinator = IOKAMainCoordinator(navigationViewController: self.navigationController ?? UINavigationController())
                    coordinator.startPaymentCoordinator()
                    coordinator.topViewController = self
                }
              
            }
        }
    }
}
