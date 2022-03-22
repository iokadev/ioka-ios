//
//  LanguageProfileView.swift
//  IOKA
//
//  Created by ablai erzhanov on 16.03.2022.
//

import Foundation
import UIKit



class LanguageProfileView: UIView {
    
    let creditCardImageView = IokaImageView(imageName: "Language")
    let languageLabel = IokaLabel(title: "Язык", iokaFont: Typography.body, iokaTextColor: IokaColors.fill2)
    let currentLanguageLabel = IokaLabel(title: "Русский", iokaFont: Typography.body, iokaTextColor: IokaColors.grey)
    let chevronRightImageView = IokaImageView(imageName: "chevronRight")
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        self.backgroundColor = IokaColors.fill6
        self.layer.cornerRadius = 8
        [creditCardImageView, languageLabel, currentLanguageLabel, chevronRightImageView].forEach{ self.addSubview($0) }
        
        creditCardImageView.snp.makeConstraints { make in
            make.height.width.equalTo(24)
            make.leading.top.equalToSuperview().inset(16)
        }
        
        languageLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(18)
            make.leading.equalTo(creditCardImageView.snp.trailing).offset(14)
        }
        
        chevronRightImageView.snp.makeConstraints { make in
            make.width.height.equalTo(20)
            make.top.equalToSuperview().inset(18)
            make.trailing.equalToSuperview().inset(16)
        }
        
        currentLanguageLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(18)
            make.trailing.equalToSuperview().inset(48)
        }
    }
}

