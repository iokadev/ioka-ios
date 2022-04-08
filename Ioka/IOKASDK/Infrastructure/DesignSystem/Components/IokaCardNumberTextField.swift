//
//  CustomCardNumberTextField.swift
//  IOKA
//
//  Created by ablai erzhanov on 14.03.2022.
//

import Foundation
import UIKit



internal class IokaCardNumberTextField: IokaTextField {
    
    
    let iconContainerView: UIView = {
        let view = UIView()
        view.frame =  CGRect(x: 0, y: 0, width: 0, height: 56)
        view.backgroundColor = .clear
        
        return view
    }()
   
    let cardBrandImageView = IokaImageView(frame: CGRect(x: -52, y: 20, width: 24, height: 16))
    let bankEmitterImageView = IokaImageView(frame: CGRect(x: -80, y: 20, width: 24, height: 16))
    var isCardBrandSetted: Bool = false
    var isBankEmitterSetted: Bool = false

   
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI() {
        self.rightView = iconContainerView
        rightViewMode = .always
        cardBrandImageView.contentMode = .scaleAspectFit
    }
    
    func setCardBrandIcon(imageName: String) {
        guard let image = UIImage(named: imageName) else { return }
        cardBrandImageView.image = image
        
        iconContainerView.addSubview(cardBrandImageView)
        self.isCardBrandSetted = true
    }
    
    func setBankEmitterIcon(imageName: String) {
        guard let image = UIImage(named: imageName) else { return }
        bankEmitterImageView.image = image
        iconContainerView.addSubview(bankEmitterImageView)
        self.isBankEmitterSetted = true
    }
}
