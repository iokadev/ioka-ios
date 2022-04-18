//
//  OrderStatusViewController.swift
//  iOKA
//
//  Created by ablai erzhanov on 02.03.2022.
//

import UIKit

internal class PaymentResultViewController: UIViewController {
    lazy var contentView = PaymentResultView(order: viewModel.order, result: viewModel.result)
    var viewModel: PaymentResultViewModel!
    
    override func loadView() {
        self.view = contentView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationItem()
        self.contentView.delegate = self
    }
    
    private func setupNavigationItem() {
        setupNavigationItem(title: nil, closeButtonTarget: self, closeButtonAction: #selector(closeButtonTapped))
    }
    
    @objc private func closeButtonTapped() {
        viewModel.close()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let feedbackGenerator = UINotificationFeedbackGenerator()
        
        switch viewModel.result {
        case .success:
            feedbackGenerator.notificationOccurred(.success)
        case .error:
            feedbackGenerator.notificationOccurred(.error)
        }
    }
}

extension PaymentResultViewController: PaymentResultViewDelegate {
    func retry() {
        viewModel.retry()
    }
    
    func close() {
        viewModel.close()
    }
    
    
}
