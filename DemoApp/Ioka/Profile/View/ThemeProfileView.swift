//
//  ThemeProfileView.swift
//  IOKA
//
//  Created by ablai erzhanov on 16.03.2022.
//


import UIKit



internal class ThemeProfileView: UIView {
    
    let themeImageView = DemoImageView(imageName: "Theme")
    let languageLabel = DemoLabel(title: "Темная тема", font: typography.body, textColor: colors.text)
    let themeToggle = UISwitch()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        self.backgroundColor = colors.quaternaryBackground
        self.layer.cornerRadius = 8
        [themeImageView, languageLabel, themeToggle].forEach{ self.addSubview($0) }
        
        themeImageView.anchor(top: self.topAnchor, left: self.leftAnchor, paddingTop: 16, paddingLeft: 16, width: 24, height: 24)
        
        languageLabel.anchor(top: self.topAnchor, left: themeImageView.rightAnchor, bottom: self.bottomAnchor, paddingTop: 18, paddingLeft: 14, paddingBottom: 18)
        
        themeToggle.anchor(top: self.topAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, paddingTop: 12, paddingBottom: 12, paddingRight: 16)
    }
}
