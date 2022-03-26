//
//  GetCardTableViewCell.swift
//  IOKA
//
//  Created by ablai erzhanov on 16.03.2022.
//

import UIKit



class GetCardTableViewCell: UITableViewCell {
    static let cellId = "GetCardTableViewCell"
    
    let creditCardImageView = IokaImageView()
    let cardNumberLabel = IokaLabel(iokaFont: Typography.body, iokaTextColor: DemoAppColors.fill2)
    let deleteImageView = IokaImageView(imageName: "deleteProduct")
    let seperatorView: UIView = IokaCustomView(backGroundColor: DemoAppColors.fill4)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(model: GetCardResponse) {
        self.cardNumberLabel.text = model.pan_masked.trimPanMasked()
        guard let paymentSystem = model.payment_system else { return }
        self.creditCardImageView.image = UIImage(named: paymentSystem)
    }
    
    private func setupUI() {
        self.backgroundColor = DemoAppColors.fill6
        self.layer.cornerRadius = 8
        [creditCardImageView, cardNumberLabel, seperatorView].forEach{ self.addSubview($0) }
        
        creditCardImageView.anchor(top: self.topAnchor, left: self.leftAnchor, bottom: self.bottomAnchor, paddingTop: 20, paddingLeft: 16, paddingBottom: 20, width: 24, height: 16)
        
        cardNumberLabel.centerY(in: creditCardImageView, left: creditCardImageView.rightAnchor, paddingLeft: 12)
        
        seperatorView.anchor(top: creditCardImageView.bottomAnchor, right: self.rightAnchor, paddingTop: 20, height: 1)
    }
}
