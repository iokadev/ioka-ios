//
//  SaveCardProfileView.swift
//  IOKA
//
//  Created by ablai erzhanov on 16.03.2022.
//

import UIKit



internal class SaveCardProfileView: UIView {
    
    let creditCardImageView = DemoImageView(imageName: "Credit-card")
    let saveCardlabel = DemoLabel(title: "Сохраненные карты", font: typography.body, textColor: colors.text)
    let chevronRightImageView = DemoImageView(imageName: "chevronRight")
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        self.backgroundColor = colors.tertiaryBackground
        self.layer.cornerRadius = 8
        [creditCardImageView, saveCardlabel, chevronRightImageView].forEach{ self.addSubview($0) }

        creditCardImageView.anchor(top: self.topAnchor, left: self.leftAnchor, paddingTop: 16, paddingLeft: 16, width: 24, height: 24)
        
        saveCardlabel.anchor(top: self.topAnchor, left: creditCardImageView.rightAnchor, bottom: self.bottomAnchor, paddingTop: 18, paddingLeft: 14, paddingBottom: 18)
        
        chevronRightImageView.anchor(top: self.topAnchor, right: self.rightAnchor, paddingTop: 18, paddingRight: 16, width: 20, height: 20)
    }
}
