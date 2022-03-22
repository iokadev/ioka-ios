//
//  ThemeProfileView.swift
//  IOKA
//
//  Created by ablai erzhanov on 16.03.2022.
//

import Foundation
import UIKit



class ThemeProfileView: UIView {
    
    let creditCardImageView = IokaImageView(imageName: "Theme")
    let languageLabel = IokaLabel(title: "Темная тема", iokaFont: Typography.body, iokaTextColor: IokaColors.fill2)
    let themeToggle = UISwitch()
    
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
        [creditCardImageView, languageLabel, themeToggle].forEach{ self.addSubview($0) }
        
        creditCardImageView.snp.makeConstraints { make in
            make.height.width.equalTo(24)
            make.leading.top.equalToSuperview().inset(16)
        }
        
        languageLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(18)
            make.leading.equalTo(creditCardImageView.snp.trailing).offset(14)
        }
        
        themeToggle.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(12)
            make.trailing.equalToSuperview().inset(16)
        }
    }
}
