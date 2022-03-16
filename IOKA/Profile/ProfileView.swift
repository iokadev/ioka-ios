//
//  ProfileView.swift
//  IOKA
//
//  Created by ablai erzhanov on 16.03.2022.
//

import Foundation


import Foundation
import UIKit



protocol ProfileViewDelegate: NSObject {
    func showSavedCard(_ profileView: ProfileView)
}

class ProfileView: UIView {
    
    weak var delegate: ProfileViewDelegate?
    
    let navigationTitleLabel = CustomLabel(title: "Профиль", customFont: Typography.title, customTextColor: CustomColors.fill2)
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

        self.backgroundColor = CustomColors.fill5
        [navigationTitleLabel, saveCardProfileView, languageProfileView, themeProfileView].forEach{ self.addSubview($0) }
        
        navigationTitleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(18)
            make.top.equalToSuperview().offset(60)
        }
        
        saveCardProfileView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(56)
            make.top.equalToSuperview().offset(116)
        }
        
        languageProfileView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(56)
            make.top.equalTo(saveCardProfileView.snp.bottom).offset(8)
        }
        
        themeProfileView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(56)
            make.top.equalTo(languageProfileView.snp.bottom).offset(8)
        }
    }
}

