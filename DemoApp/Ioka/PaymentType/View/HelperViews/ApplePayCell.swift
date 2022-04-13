//
//  ApplePayCell.swift
//  IOKA
//
//  Created by ablai erzhanov on 25.03.2022.
//

import UIKit

internal protocol ApplePayCellDelegate: NSObject {
    func handleViewTap(_ view: ApplePayCell, isPayWithCashSelected: Bool)
}

internal class ApplePayCell: UITableViewCell {
    static let cellId = "ApplePayCell"
    
    let applePayImageView = DemoImageView(imageName: "Apple_Pay_Mark_RGB_041619")
    let applePayLabel = DemoLabel( title: "Apple pay", font: typography.body, textColor: colors.text)
    let checkImageView = DemoImageView(imageName: "uncheckIcon")
    var isViewSelected: Bool = false
    weak var delegate: ApplePayCellDelegate?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setActions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(delegate: ApplePayCellDelegate) {
        self.delegate = delegate
    }
    
    public func uncheckView() {
        self.checkImageView.image = DemoImages.uncheckIcon
    }
    
    public func checkkView() {
        self.checkImageView.image = DemoImages.checkIcon
    }
    
    public func changeViewSelection() {
        switch isViewSelected {
        case true:
            checkkView()
        case false:
            uncheckView()
        }
    }
    
    private func setActions() {
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleView)))
    }
    
    @objc private func handleView() {
        self.isViewSelected.toggle()
        changeViewSelection()
        delegate?.handleViewTap(self, isPayWithCashSelected: isViewSelected)
    }
    
    private func setupUI() {
        self.backgroundColor = colors.tertiaryBackground
        self.layer.cornerRadius = 8
        applePayImageView.contentMode = .scaleAspectFit
        [applePayImageView, applePayLabel, checkImageView].forEach{ self.contentView.addSubview($0) }
        
        applePayImageView.centerY(in: self, left: self.contentView.leftAnchor, paddingLeft: 16, width: 24, height: 24)
        
        applePayLabel.centerY(in: self, left: applePayImageView.rightAnchor, paddingLeft: 12)
        
        checkImageView.centerY(in: self, right: self.contentView.rightAnchor, paddingRight: 16, width: 24, height: 24)
    }
}
