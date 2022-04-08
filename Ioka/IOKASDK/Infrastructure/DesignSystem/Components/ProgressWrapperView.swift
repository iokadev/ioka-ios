//
//  ProgressWrapperView.swift
//  IOKA
//
//  Created by ablai erzhanov on 04.04.2022.
//

import UIKit

internal enum ProgressWrapperViewState {
    case payment
    case order
}


internal class ProgressWrapperView: UIView {
    
    private let progressView = IokaProgressView()
    private let titleLabel = IokaLabel(iokaFont: typography.title, iokaTextColor: colors.background, iokaTextAlignemnt: .center)
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    convenience init(state: ProgressWrapperViewState) {
        self.init()
        switch state {
        case .payment:
            titleLabel.text = IokaLocalizable.paymentProcessing
        case .order:
            titleLabel.text = IokaLocalizable.goPayment
        }
    }
    
    func animate() {
        progressView.startIndicator()
    }
    
    func stop() {
        progressView.stopIndicator()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setupUI() {
        self.backgroundColor = colors.foreground
        [progressView, titleLabel].forEach { self.addSubview($0) }
        
        progressView.center(in: self, in: self, width: 80, height: 80)
        titleLabel.centerX(in: self, top: progressView.bottomAnchor, paddingTop: 16)
    }
}
