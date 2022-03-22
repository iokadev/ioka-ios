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
        
        addCardImageView.snp.makeConstraints { make in
            make.width.equalTo(24)
            make.height.equalTo(16)
            make.leading.equalToSuperview().inset(16)
            make.top.bottom.equalToSuperview().inset(20)
        }
        
        addCardLabel.snp.makeConstraints { make in
            make.leading.equalTo(addCardImageView.snp.trailing).offset(12)
            make.centerY.equalTo(addCardImageView.snp.centerY)
        }
        
        showAddCardimageView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(16)
            make.centerY.equalTo(addCardImageView.snp.centerY)
        }
    }
}

