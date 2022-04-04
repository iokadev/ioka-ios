//
//  CustomButton.swift
//  iOKA
//
//  Created by ablai erzhanov on 27.02.2022.
//

import Foundation
import UIKit

enum IokaButtonState {
    case disabled
    case enabled
    case savingSuccess
    case savingFailure
}

class IokaButton: UIButton {
    
    var iokaButtonState: IokaButtonState? {
        didSet {
            handlePayButtonState(state: iokaButtonState)
        }
    }
    var title: String?
    var image: UIImage?
    let activityIndicator = UIActivityIndicatorView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(iokaButtonState: IokaButtonState? = nil, title: String? = nil, imageName: String? = nil, backGroundColor: UIColor? = nil) {
        self.init(frame: CGRect())
        self.iokaButtonState = iokaButtonState
        self.title = title
        self.image = UIImage(named: imageName ?? "")
        self.backgroundColor = backGroundColor
        setupButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func showSuccess() {
        DispatchQueue.main.async {
            self.setImage(IokaImages.mark, for: .normal)
        }
    }

    public func showLoading() {
        DispatchQueue.main.async {
            self.title = self.titleLabel?.text
            self.setTitle("", for: .normal)
            let activityIndicator = self.createActivityIndicator()
            
            self.showSpinning(activityIndicator)
        }
    }

    public func hideLoading(showTitle: Bool) {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            switch showTitle {
            case true:
                self.setTitle(self.title, for: .normal)
            case false:
                self.setTitle("", for: .normal)
            }
        }
    }

    
    private func setupButton() {
        self.setTitle(title, for: .normal)
        self.setImage(image, for: .normal)
        self.layer.cornerRadius = 12
        handlePayButtonState(state: iokaButtonState)
    }
    
    private func handlePayButtonState(state: IokaButtonState?) {
        guard let state = state else { return }

        switch state {
        case .disabled:
            self.backgroundColor = IOKA.shared.theme.grey
        case .enabled:
            self.backgroundColor = IOKA.shared.theme.primary
        case .savingSuccess:
            self.backgroundColor = IOKA.shared.theme.success
            self.hideLoading(showTitle: true)
            showSuccess()
        case .savingFailure:
            hideLoading(showTitle: true)
            self.backgroundColor = IOKA.shared.theme.grey
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
