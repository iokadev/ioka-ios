//
//  ErrorPopupViewController.swift
//  IOKA
//
//  Created by ablai erzhanov on 04.04.2022.
//

import UIKit

internal class ErrorPopupViewController: UIViewController {
    
    var viewModel: ErrorPopupViewModel!
    private lazy var contentView = ErrorPopupView(error: viewModel.error)
    
    override func loadView() {
        self.view = contentView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        contentView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UINotificationFeedbackGenerator().notificationOccurred(.error)
    }
}

extension ErrorPopupViewController: ErrorPopupViewDelegate {
    func close() {
        viewModel.close()
    }
}
