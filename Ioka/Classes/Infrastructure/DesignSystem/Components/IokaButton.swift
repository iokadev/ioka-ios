//
//  CustomButton.swift
//  iOKA
//
//  Created by ablai erzhanov on 27.02.2022.
//

import Foundation
import UIKit

internal class IokaButton: UIButton {
    enum State {
        case disabled
        case enabled
        case loading
        case success
    }
    
    var iokaState: State? {
        didSet {
            handlePayButtonState(state: iokaState)
        }
    }
    
    var title: String? {
        didSet {
            self.setTitle(title, for: .normal)
        }
    }
    
    var imageName: String?
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.color = .lightGray
        
        return activityIndicator
    }()
    
    init(state: State? = nil, title: String? = nil, imageName: String? = nil, tintColor: UIColor? = nil, backgroundColor: UIColor? = nil) {
        self.title = title
        self.imageName = imageName
        self.iokaState = state
        
        super.init(frame: .zero)

        self.tintColor = tintColor
        self.backgroundColor = backgroundColor

        setupButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupButton() {
        self.setTitle(title, for: .normal)
        self.layer.cornerRadius = 12
        handlePayButtonState(state: iokaState)
        if let imageName = imageName {
            var image = UIImage(named: imageName, in: IokaBundle.bundle, compatibleWith: nil)
            if tintColor != nil {
                image = image?.withRenderingMode(.alwaysTemplate)
            }
            
            self.setImage(image, for: .normal)
        }
    }
    
    private func handlePayButtonState(state: State?) {
        guard let state = state else { return }

        self.hideActivityIndicator()

        switch state {
        case .disabled:
            self.backgroundColor = colors.nonadaptableGrey
            self.isUserInteractionEnabled = false
            self.setTitle(title, for: .normal)
        case .enabled:
            self.backgroundColor = colors.primary
            self.isUserInteractionEnabled = true
            self.setTitle(title, for: .normal)
        case .loading:
            self.backgroundColor = colors.primary
            self.isUserInteractionEnabled = false
            self.title = self.titleLabel?.text
            self.setTitle("", for: .normal)
            self.showActivityIndicator()
        case .success:
            self.backgroundColor = colors.success
            self.isUserInteractionEnabled = true
            self.setImage(IokaImages.mark, for: .normal)
            self.setTitle("", for: .normal)
        }
    }

    private func showActivityIndicator() {
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(activityIndicator)
        centerActivityIndicatorInButton(activityIndicator)
        activityIndicator.startAnimating()
    }
    
    private func hideActivityIndicator() {
        activityIndicator.removeFromSuperview()
        activityIndicator.stopAnimating()
    }
    
    private func centerActivityIndicatorInButton(_ activityIndicator: UIActivityIndicatorView) {
        activityIndicator.center(in: self, in: self)
    }

}
