//
//  CustomButton.swift
//  iOKA
//
//  Created by ablai erzhanov on 27.02.2022.
//

import Foundation
import UIKit

internal enum IokaButtonState {
    case disabled
    case enabled
    case savingSuccess
}

internal class IokaButton: UIButton {
    
    var iokaButtonState: IokaButtonState? {
        didSet {
            handlePayButtonState(state: iokaButtonState)
        }
    }
    var title: String?
    var imageName: String?
    let activityIndicator = UIActivityIndicatorView()
    
    init(iokaButtonState: IokaButtonState? = nil, title: String? = nil, imageName: String? = nil, tintColor: UIColor? = nil, backgroundColor: UIColor? = nil) {
        self.title = title
        self.imageName = imageName
        self.iokaButtonState = iokaButtonState
        
        super.init(frame: .zero)

        self.tintColor = tintColor
        self.backgroundColor = backgroundColor

        setupButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func showSuccess() {
        self.setImage(IokaImages.mark, for: .normal)
        self.setTitle("", for: .normal)
    }

    func showLoading() {
        self.title = self.titleLabel?.text
        self.setTitle("", for: .normal)
        let activityIndicator = self.createActivityIndicator()
        
        self.showSpinning(activityIndicator)
    }

    func hideLoading(showTitle: Bool) {
        self.activityIndicator.stopAnimating()
        switch showTitle {
        case true:
            self.setTitle(self.title, for: .normal)
        case false:
            self.setTitle("", for: .normal)
        }
    }

    
    private func setupButton() {
        self.setTitle(title, for: .normal)
        self.layer.cornerRadius = 12
        handlePayButtonState(state: iokaButtonState)
        if let imageName = imageName {
            var image = UIImage(named: imageName, in: IokaBundle.bundle, compatibleWith: nil)
            if tintColor != nil {
                image = image?.withRenderingMode(.alwaysTemplate)
            }
            
            self.setImage(image, for: .normal)
        }
    }
    
    private func handlePayButtonState(state: IokaButtonState?) {
        guard let state = state else { return }

        switch state {
        case .disabled:
            self.backgroundColor = colors.nonadaptableGrey
            self.isUserInteractionEnabled = false
        case .enabled:
            self.backgroundColor = colors.primary
            self.isUserInteractionEnabled = true
        case .savingSuccess:
            self.backgroundColor = colors.success
            self.hideLoading(showTitle: true)
            self.isUserInteractionEnabled = true
            showSuccess()
        }
    }
    
    private func createActivityIndicator() -> UIActivityIndicatorView {
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = .lightGray
        return activityIndicator
    }

    private func showSpinning(_ activityIndicator: UIActivityIndicatorView) {
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(activityIndicator)
        centerActivityIndicatorInButton(activityIndicator)
        activityIndicator.startAnimating()
    }
    
    private func centerActivityIndicatorInButton(_ activityIndicator: UIActivityIndicatorView) {
        activityIndicator.center(in: self, in: self)
    }

}
