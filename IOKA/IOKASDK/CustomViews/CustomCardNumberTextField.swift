//
//  CustomCardNumberTextField.swift
//  IOKA
//
//  Created by ablai erzhanov on 14.03.2022.
//

import Foundation
import UIKit



class CustomCardNumberTextField: CustomTextField {
    
    
    let iconContainerView: UIView = {
        let view = UIView()
        view.frame =  CGRect(x: 0, y: 0, width: 90, height: 10)
        view.backgroundColor = .clear
        
        return view
    }()
   
    let cardBrandImageView = CustomImageView(cornerRadius: 2)
    let bankEmitterImageView = CustomImageView(cornerRadius: 2)
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
        
//        iconContainerView.addSubview(bankEmitterImageView)
//        bankEmitterImageView.snp.makeConstraints { make in
//            make.trailing.equalToSuperview().inset(52)
//            make.height.equalTo(16)
//            make.width.equalTo(24)
//            make.centerY.equalToSuperview()
//        }
    }
    
    func setCardBrandIcon(imageName: String) {
        guard let image = UIImage(named: imageName) else { return }
        cardBrandImageView.image = image
        
        iconContainerView.addSubview(cardBrandImageView)
        cardBrandImageView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(52)
            make.height.equalTo(16)
            make.width.equalTo(24)
            make.centerY.equalToSuperview()
        }

        self.isCardBrandSetted = true
    }
    
    func setBankEmitterIcon(imageName: String) {
        guard let image = UIImage(named: imageName) else { return }
        bankEmitterImageView.image = image
        iconContainerView.addSubview(bankEmitterImageView)
        bankEmitterImageView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(80)
            make.height.equalTo(16)
            make.width.equalTo(24)
            make.centerY.equalToSuperview()
        }
        self.isBankEmitterSetted = true
    }
}
