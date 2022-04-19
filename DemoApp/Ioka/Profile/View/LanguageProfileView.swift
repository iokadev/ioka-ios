//
//  LanguageProfileView.swift
//  IOKA
//
//  Created by ablai erzhanov on 16.03.2022.
//

import Foundation
import UIKit



internal class LanguageProfileView: UIView {
    
    let languageImageView = DemoImageView(imageName: "Language")
    let languageLabel = DemoLabel(title: "Язык", font: typography.body, textColor: colors.text)
    let currentLanguageLabel = DemoLabel(title: "Русский", font: typography.body, textColor: colors.nonadaptableGrey)
    let chevronRightImageView = DemoImageView(imageName: "chevronRight")
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(locale: Locale) {
        currentLanguageLabel.text = locale.label
    }
    
    private func setupUI() {
        self.backgroundColor = colors.quaternaryBackground
        self.layer.cornerRadius = 8
        [languageImageView, languageLabel, currentLanguageLabel, chevronRightImageView].forEach{ self.addSubview($0) }
        
        languageImageView.anchor(top: self.topAnchor, left: self.leftAnchor, paddingTop: 16, paddingLeft: 16, width: 24, height: 24)
        
        languageLabel.anchor(top: self.topAnchor, left: languageImageView.rightAnchor, bottom: self.bottomAnchor, paddingTop: 18, paddingLeft: 14, paddingBottom: 18)
        
        chevronRightImageView.anchor(top: self.topAnchor, right: self.rightAnchor, paddingTop: 18, paddingRight: 16, width: 20, height: 20)
        
        currentLanguageLabel.anchor(top: self.topAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, paddingTop: 18, paddingBottom: 18, paddingRight: 48)
    }
}
