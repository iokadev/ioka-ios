//
//  IokaButton.swift
//  iOKA
//
//  Created by ablai erzhanov on 27.02.2022.
//

import Foundation
import UIKit

enum IokaButtonState {
    case disabled
    case enabled
}

class IokaButton: UIButton {
    
    var iokaButtonState: IokaButtonState? {
        didSet {
            handlePayButtonState(state: iokaButtonState)
        }
    }
    var title: String?
    var image: UIImage?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(iokaButtonState: IokaButtonState? = nil, title: String? = nil, image: UIImage? = nil) {
        self.init(frame: CGRect())
        self.iokaButtonState = iokaButtonState
        self.title = title
        self.image = image
        setupButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
            self.backgroundColor = IokaColors.grey
        case .enabled:
            self.backgroundColor = IokaColors.primary
        }
    }


    func showLoading() {
        self.title = self.titleLabel?.text
        self.setTitle("", for: .normal)
        let activityIndicator = createActivityIndicator()
        
        showSpinning(activityIndicator)
    }

//    func hideLoading() {
//        self.setTitle(self.title, for: .normal)
//        activityIndicator.stopAnimating()
//    }

    private func createActivityIndicator() -> UIActivityIndicatorView {
        let activityIndicator = UIActivityIndicatorView()
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
