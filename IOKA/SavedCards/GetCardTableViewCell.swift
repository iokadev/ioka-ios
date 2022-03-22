//
//  GetCardTableViewCell.swift
//  IOKA
//
//  Created by ablai erzhanov on 16.03.2022.
//

import Foundation
import UIKit



class GetCardTableViewCell: UITableViewCell {
    static let cellId = "GetCardTableViewCell"
    
    let creditCardImageView = IokaImageView()
    let cardNumberLabel = IokaLabel(iokaFont: Typography.body, iokaTextColor: IokaColors.fill2)
    let deleteImageView = IokaImageView(imageName: "deleteProduct")
    let seperatorView: UIView = IokaCustomView(backGroundColor: IokaColors.fill4)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(model: GetCardResponse) {
        self.cardNumberLabel.text = model.pan_masked
        guard let paymentSystem = model.payment_system else { return }
        self.creditCardImageView.image = UIImage(named: paymentSystem)
    }
    
    private func setupUI() {
        self.backgroundColor = IokaColors.fill6
        self.layer.cornerRadius = 8
        [creditCardImageView, cardNumberLabel, seperatorView].forEach{ self.addSubview($0) }
        
        creditCardImageView.snp.makeConstraints { make in
            make.width.equalTo(24)
            make.height.equalTo(16)
            make.leading.equalToSuperview().inset(16)
            make.top.bottom.equalToSuperview().inset(20)
        }
        
        cardNumberLabel.snp.makeConstraints { make in
            make.leading.equalTo(creditCardImageView.snp.trailing).offset(12)
            make.centerY.equalTo(creditCardImageView.snp.centerY)
        }
        
        seperatorView.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.height.equalToSuperview()
            make.top.equalTo(creditCardImageView.snp.bottom).offset(20)
        }
    }
}
