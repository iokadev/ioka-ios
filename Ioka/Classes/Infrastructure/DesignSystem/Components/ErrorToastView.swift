//
//  ErrorView.swift
//  IOKA
//
//  Created by ablai erzhanov on 25.03.2022.
//

import UIKit

internal class ErrorToastView: UIView {
    
    var error: Error? {
        didSet {
            configureErrorView(error: error)
        }
    }
    
    private var onHide: (() -> Void)?
    
    private let errorLabel = IokaLabel(iokaFont: typography.subtitle, iokaTextColor: colors.nonadaptableText, iokaTextAlignemnt: .left)
    private let closeButton = IokaButton(imageName: "closeError")
    
    private var hidingTimer: Timer?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        hide()
        setUI()
        setActions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func show(error: Error, onHide: (() -> Void)? = nil) {
        self.error = error
        self.onHide = onHide
        UIView.animate(withDuration: 1.0) {
            self.alpha = 1.0
        } completion: { _ in
            self.hidingTimer?.invalidate()
            self.hidingTimer = Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { [weak self] _ in
                guard let self = self else { return }
                
                self.hidingTimer?.invalidate()
                self.hidingTimer = nil
                
                UIView.animate(withDuration: 1.0) {
                    self.hide()
                }
            }
        }
    }
    
    func hide() {
        self.onHide?()
        self.alpha = 0.0
    }
    
    private func configureErrorView(error: Error?) {
        self.errorLabel.text = error?.localizedDescription
    }
    
    private func setActions() {
        closeButton.addTarget(self, action: #selector(handleCloseButton), for: .touchUpInside)
    }
    
    @objc private func handleCloseButton() {
        hide()
    }
    
    private func setUI() {
        self.backgroundColor = colors.error
        self.layer.cornerRadius = 12
        [errorLabel, closeButton].forEach{ self.addSubview($0) }
        
        errorLabel.anchor(top: self.topAnchor, left: self.leftAnchor, bottom: self.bottomAnchor,right: self.rightAnchor, paddingTop: 12, paddingLeft: 16,paddingBottom: 12, paddingRight: 48)
        
        closeButton.centerY(in: errorLabel, right: self.rightAnchor, paddingRight: 16, width: 24, height: 24)
    }
}
