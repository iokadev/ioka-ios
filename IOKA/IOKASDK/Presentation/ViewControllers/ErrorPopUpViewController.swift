//
//  ErrorPopUpViewController.swift
//  IOKA
//
//  Created by ablai erzhanov on 04.04.2022.
//

import UIKit

class ErrorPopUpViewController: IokaViewController {
    
    var viewModel: ErrorPopUpViewModel!
    var error: IokaError!
    private let contentView = ErrorPopUpView()
    
    
    override func loadView() {
        super.loadView()
        self.view = contentView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        contentView.delegate = self
        contentView.configureView(error: error)
    }
}

extension ErrorPopUpViewController: ErrorPopUpViewDelegate {
    func dismissView(_ view: ErrorPopUpView) {
        viewModel.dismiss()
    }
}
