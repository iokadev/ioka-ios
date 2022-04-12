//
//  ViewControllerProgressWrapper.swift
//  Ioka
//
//  Created by ablai erzhanov on 06.04.2022.
//

import UIKit


internal class ViewControllerProgressWrapper {
    
    let viewController: UIViewController
    var viewModel: ProgressViewModelProtocol
    private lazy var progressView = ProgressWrapperView(state: .order)
    private lazy var errorView = ErrorToastView()
    var theme: IokaTheme!
    
    init(viewController: UIViewController, viewModel: ProgressViewModelProtocol) {
        self.viewController = viewController
        self.viewModel = viewModel
        viewModel.getOrder()
        setUI()
    }
    
    func startProgress() {
        progressView.isHidden = false
        progressView.animate()
    }
    
    func hideProgress() {
        progressView.isHidden = true
        progressView.stop()
    }
    
    func showError(error: Error) {
        self.errorView.error = error
        UIView.transition(with:  self.errorView, duration: 0.4,
                          options: .transitionCrossDissolve,
                          animations: { [self] in
            self.errorView.isHidden = false
        })
    }
    
    func hideError() {
        UIView.transition(with:  self.errorView, duration: 0.4,
                          options: .transitionCrossDissolve,
                          animations: { [self] in
            self.errorView.isHidden = true
        })
    }
    
    
    func setUI() {
        errorView.isHidden = true
        self.viewController.navigationController?.view.addSubview(errorView)
        self.errorView.anchor(left: self.viewController.view.leftAnchor, bottom: viewController.view.bottomAnchor, right: viewController.view.rightAnchor, paddingLeft: 16, paddingBottom: 114, paddingRight: 16)
        
        self.viewController.navigationController?.view.addSubview(progressView)
        progressView.fillView(viewController.view)
    }
}
