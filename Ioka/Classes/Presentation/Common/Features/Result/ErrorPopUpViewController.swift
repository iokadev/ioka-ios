//
//  ErrorPopUpViewController.swift
//  IOKA
//
//  Created by ablai erzhanov on 04.04.2022.
//

import UIKit

internal class ErrorPopUpViewController: UIViewController {
    
    var viewModel: ErrorPopUpViewModel!
    var theme: IokaTheme!
    private let contentView = ErrorPopUpView()
    let feedbackGenerator = UIImpactFeedbackGenerator(style: .heavy)
    
    
    override func loadView() {
        self.view = contentView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        contentView.delegate = self
        feedbackGenerator.impactOccurred()
    }
    
    func showError(_ error: Error) {
        self.contentView.configureView(error: error)
    }
}

extension ErrorPopUpViewController: ErrorPopUpViewDelegate {
    func dismissView(_ view: ErrorPopUpView) {
        viewModel.dismiss()
    }
}
