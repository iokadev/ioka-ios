//
//  AddNewCardTableViewCell.swift
//  IOKA
//
//  Created by ablai erzhanov on 16.03.2022.
//

import Foundation
import UIKit



class AddNewCardTableViewCell: UITableViewCell {
    static let cellId = "AddNewCardTableViewCell"
    
    let addCardImageView = IokaImageView(imageName: "addCard")
    let addCardLabel = IokaLabel( title: "Добавить новую карту", iokaFont: Typography.body, iokaTextColor: IokaColors.fill2)
    let showAddCardimageView = IokaImageView(imageName: "chevronRight")
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        self.backgroundColor = IokaColors.fill6
        self.layer.cornerRadius = 8
        addCardImageView.contentMode = .scaleAspectFit
        [addCardImageView, addCardLabel, showAddCardimageView].forEach{ self.contentView.addSubview($0) }
        
        
        addCardImageView.anchor(top: self.contentView.topAnchor, left: self.contentView.leftAnchor, bottom: self.contentView.bottomAnchor, paddingTop: 20, paddingLeft: 16, paddingBottom: 20, width: 24, height: 16)
        
        addCardLabel.centerY(in: addCardImageView, left: addCardImageView.rightAnchor, paddingLeft: 12)
        
        showAddCardimageView.centerY(in: addCardImageView, right: self.contentView.rightAnchor, paddingRight: 16)
    }
}

