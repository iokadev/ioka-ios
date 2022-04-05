//
//  GetOrderForPaymentViewController.swift
//  IOKA
//
//  Created by ablai erzhanov on 04.04.2022.
//


import UIKit


class GetOrderForPaymentViewController: UIViewController, ErrorToastViewDelegate {
    
    private lazy var contentView = ProgressWrapperView(state: .order)
    private lazy var errorView = ErrorToastView()
    var viewModel: GetOrderForPaymentViewModel!
    
    override func loadView() {
        super.loadView()
        self.view.backgroundColor = .clear
        self.view.addSubview(contentView)
        contentView.fillView(self.view)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.getOrder()
        errorView.delegate = self
        viewModel.orderErrorCallBack = { [weak self] error in
            guard let self = self else { return }
            self.showErrorView(error: error)
        }
    }
    
    func showErrorView(error: IokaError) {
        DispatchQueue.main.async {
            self.contentView.isHidden = true
            self.errorView.error = error
            self.view.addSubview(self.errorView)
            self.errorView.anchor(left: self.view.leftAnchor, bottom: self.view.bottomAnchor, right: self.view.rightAnchor, paddingLeft: 16, paddingBottom: 114, paddingRight: 16)
        }
    }
    
    func closeErrorView(_ view: ErrorToastView) {
        DispatchQueue.main.async {
            self.errorView.removeFromSuperview()
            self.viewModel.delegate?.dismissGetOrderProgressWrapper()
        }
    }
}
