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
        let controller = viewController.navigationController ?? viewController
        controller.view.addSubview(errorView)
        self.errorView.anchor(left: controller.view.leftAnchor,
                              bottom: controller.view.safeAreaBottomAnchor,
                              right: controller.view.rightAnchor,
                              paddingLeft: 16,
                              paddingBottom: 16,
                              paddingRight: 16)
        
        controller.view.addSubview(progressView)
        progressView.fillView(controller.view)
    }
    
    deinit {
        errorView.removeFromSuperview()
        progressView.removeFromSuperview()
    }
}
