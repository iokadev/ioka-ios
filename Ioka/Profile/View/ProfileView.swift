//
//  ProfileView.swift
//  IOKA
//
//  Created by ablai erzhanov on 16.03.2022.
//


import UIKit



internal protocol ProfileViewDelegate: NSObject {
    func showSavedCard(_ profileView: ProfileView)
}

internal class ProfileView: UIView {
    
    weak var delegate: ProfileViewDelegate?
    
    let navigationTitleLabel = IokaLabel(title: "Профиль", iokaFont: typography.title, iokaTextColor: DemoAppColors.text)
    let saveCardProfileView = SaveCardProfileView()
    let languageProfileView = LanguageProfileView()
    let themeProfileView = ThemeProfileView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupActions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupActions() {
        self.saveCardProfileView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSaveCardProfileView)))
    }
    
    @objc private func handleSaveCardProfileView() {
        delegate?.showSavedCard(self)
    }
    
    private func configureView() {
        
    }
    
    private func setupUI() {

        self.backgroundColor = DemoAppColors.secondaryBackground
        [navigationTitleLabel, saveCardProfileView, languageProfileView, themeProfileView].forEach{ self.addSubview($0) }
        
        navigationTitleLabel.anchor(top: self.topAnchor, left: self.leftAnchor, paddingTop: 60, paddingLeft: 18)
        
        saveCardProfileView.anchor(top: self.topAnchor, left: self.leftAnchor, right: self.rightAnchor, paddingTop: 116, paddingLeft: 16, paddingRight: 16, height: 56)
        
        languageProfileView.anchor(top: saveCardProfileView.bottomAnchor, left: self.leftAnchor, right: self.rightAnchor, paddingTop: 8, paddingLeft: 16, paddingRight: 16, height: 56)
        
        themeProfileView.anchor(top: languageProfileView.bottomAnchor, left: self.leftAnchor, right: self.rightAnchor, paddingTop: 8, paddingLeft: 16, paddingRight: 16, height: 56)
    }
}
