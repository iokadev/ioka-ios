//
//  AddNewCardTableViewCell.swift
//  IOKA
//
//  Created by ablai erzhanov on 16.03.2022.
//

import Foundation
import UIKit


internal protocol AddNewCardTablewViewCellDelegate: NSObject {
    func viewTapped(_ view: AddNewCardTableViewCell)
}



internal class AddNewCardTableViewCell: UITableViewCell {
    static let cellId = "AddNewCardTableViewCell"
    
    let addCardImageView = DemoImageView(imageName: "addCard")
    let addCardLabel = DemoLabel( title: "Добавить новую карту", font: typography.body, textColor: colors.text)
    let showAddCardimageView = DemoImageView(imageName: "chevronRight")
    
    weak var delegate: AddNewCardTablewViewCellDelegate?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setActions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setActions() {
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleViewTap)))
    }
    
    @objc private func handleViewTap() {
        delegate?.viewTapped(self)
    }
    
    private func setupUI() {
        self.backgroundColor = colors.tertiaryBackground
        self.layer.cornerRadius = 8
        addCardImageView.contentMode = .scaleAspectFit
        [addCardImageView, addCardLabel, showAddCardimageView].forEach{ self.contentView.addSubview($0) }
        
        
        addCardImageView.anchor(top: self.contentView.topAnchor, left: self.contentView.leftAnchor, bottom: self.contentView.bottomAnchor, paddingTop: 20, paddingLeft: 16, paddingBottom: 20, width: 24, height: 16)
        
        addCardLabel.centerY(in: addCardImageView, left: addCardImageView.rightAnchor, paddingLeft: 12)
        
        showAddCardimageView.centerY(in: addCardImageView, right: self.contentView.rightAnchor, paddingRight: 16)
    }
}
