//
//  GetCardTableViewCell.swift
//  IOKA
//
//  Created by ablai erzhanov on 16.03.2022.
//

import UIKit
import Ioka

internal protocol GetCardTableViewCellDelegate: NSObject {
    func deleteCard(_ view: GetCardTableViewCell, card: SavedCard)
}



internal class GetCardTableViewCell: UITableViewCell {
    static let cellId = "GetCardTableViewCell"
    
    let creditCardImageView = DemoImageView()
    let cardNumberLabel = DemoLabel(font: typography.body, textColor: colors.text)
    let deleteImageView = DemoImageView(imageName: "deleteProduct")
    let seperatorView: UIView = DemoCustomView(backGroundColor: colors.secondaryBackground)
    let deleteCardImageView = DemoImageView(imageName: "deleteProduct")
    var card: SavedCard?
    
    weak var delegate: GetCardTableViewCellDelegate?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setActions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(model: SavedCard) {
        self.card = model
        self.cardNumberLabel.text = model.maskedPAN.trimPanMasked()
        self.creditCardImageView.image = model.paymentSystemIcon
    }
    
    private func setActions() {
        deleteCardImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDeleteImageView)))
    }
    
    @objc private func handleDeleteImageView() {
        guard let card = card else { return }
        delegate?.deleteCard(self, card: card)
    }
    
    private func setupUI() {
        
        deleteCardImageView.isUserInteractionEnabled = true
        self.backgroundColor = .clear
        [creditCardImageView, cardNumberLabel, seperatorView, deleteCardImageView].forEach{ self.contentView.addSubview($0) }
        
        creditCardImageView.anchor(top: self.topAnchor, left: self.leftAnchor, bottom: self.bottomAnchor, paddingTop: 20, paddingLeft: 16, paddingBottom: 20, width: 24, height: 16)
        
        cardNumberLabel.centerY(in: creditCardImageView, left: creditCardImageView.rightAnchor, paddingLeft: 12)
        
        seperatorView.anchor(top: creditCardImageView.bottomAnchor, left: self.leftAnchor, right: self.rightAnchor, paddingTop: 20, paddingLeft: 52, height: 1)
        
        deleteCardImageView.centerY(in: self, right: self.rightAnchor, paddingRight: 16, width: 24, height: 24)
    }
}
