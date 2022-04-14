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
    
    func showError(error: Error, onHide: (() -> Void)? = nil) {
        errorView.show(error: error, onHide: onHide)
    }
    
    func setUI() {
        self.viewController.navigationController?.view.addSubview(errorView)
        self.errorView.anchor(left: self.viewController.navigationController?.view.leftAnchor,
                              bottom: viewController.navigationController?.view.safeAreaBottomAnchor,
                              right: viewController.navigationController?.view.rightAnchor,
                              paddingLeft: 16,
                              paddingBottom: 16,
                              paddingRight: 16)
        
        self.viewController.navigationController?.view.addSubview(progressView)
        progressView.fillView(self.viewController.navigationController?.view)
    }
    
    deinit {
        errorView.removeFromSuperview()
        progressView.removeFromSuperview()
    }
}
