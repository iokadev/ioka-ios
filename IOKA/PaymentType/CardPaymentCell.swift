//
//  CardCell.swift
//  IOKA
//
//  Created by ablai erzhanov on 21.03.2022.
//

import Foundation
import UIKit

class CardCell: UITableViewCell {
    static let cellId = "ApplePayCell"
    
    let applePayImageView = CustomImageView(imageName: "ApplePay")
    let applePayLabel = CustomLabel( title: "Apple pay", customFont: Typography.body, customTextColor: CustomColors.fill2)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        self.backgroundColor = CustomColors.fill6
        self.layer.cornerRadius = 8
        applePayImageView.contentMode = .scaleAspectFit
        [applePayImageView, applePayLabel].forEach{ self.contentView.addSubview($0) }
        
        applePayImageView.snp.makeConstraints { make in
            make.width.height.equalTo(24)
            make.leading.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
        }
        
        applePayLabel.snp.makeConstraints { make in
            make.leading.equalTo(applePayImageView.snp.trailing).offset(12)
            make.centerY.equalToSuperview()
        }
    }
}
