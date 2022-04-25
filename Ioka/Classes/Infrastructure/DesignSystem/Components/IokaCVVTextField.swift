//
//  IokaCVVTextField.swift
//  CreditCardValidator
//
//  Created by ablai erzhanov on 25.04.2022.
//

import UIKit

internal class IokaCVVTextFIeld: IokaTextField {
    let iconContainerView: UIView = {
        let view = UIView()
        view.frame =  CGRect(x: -40, y: 0, width: 40, height: 56)
        view.backgroundColor = .clear
        
        return view
    }()
   
    let cvvTooltipImageView = IokaImageView(frame: CGRect(x: -40, y: 16, width: 24, height: 24))
   
    init() {
        super.init(inputType: .cvv)
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI() {
        self.rightView = iconContainerView
        rightViewMode = .always
        cvvTooltipImageView.contentMode = .scaleAspectFit
        setCVVTootip()
    }
    
    func setCVVTootip() {
        guard let image = UIImage(named: "CVVHint", in: IokaBundle.bundle, compatibleWith: nil) else { return }
        cvvTooltipImageView.image = image
        cvvTooltipImageView.image = cvvTooltipImageView.image?.withRenderingMode(.alwaysTemplate)
        cvvTooltipImageView.tintColor = colors.nonadaptableGrey
        
        self.addSubview(cvvTooltipImageView)
        cvvTooltipImageView.centerY(in: self, right: self.rightAnchor, paddingRight: 16, width: 24, height: 24)
        bringSubviewToFront(cvvTooltipImageView)
    }
}

