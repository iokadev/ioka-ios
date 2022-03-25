//
//  ApplePayCell.swift
//  IOKA
//
//  Created by ablai erzhanov on 21.03.2022.
//

import UIKit

protocol ApplePayCellDelegate: NSObject {
    func handleViewTap(_ view: ApplePayCell, isPayWithCashSelected: Bool)
}

class ApplePayCell: UITableViewCell {
    static let cellId = "ApplePayCell"
    
    let applePayImageView = IokaImageView(imageName: "Apple_Pay_Mark_RGB_041619")
    let applePayLabel = IokaLabel( title: "Apple pay", iokaFont: Typography.body, iokaTextColor: DemoAppColors.fill2)
    let checkImageView = IokaImageView(imageName: "uncheckIcon")
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
        self.checkImageView.image = DemoAppImages.uncheckIcon
    }
    
    public func checkkView() {
        self.checkImageView.image = DemoAppImages.checkIcon
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
        self.backgroundColor = DemoAppColors.fill6
        self.layer.cornerRadius = 8
        applePayImageView.contentMode = .scaleAspectFit
        [applePayImageView, applePayLabel, checkImageView].forEach{ self.contentView.addSubview($0) }
        
        applePayImageView.anchor(top: self.contentView.topAnchor, left: self.contentView.leftAnchor, bottom: self.contentView.bottomAnchor, paddingTop: 16, paddingLeft: 16, paddingBottom: 16, width: 24, height: 24)
        
        applePayLabel.centerY(in: applePayImageView, left: applePayImageView.rightAnchor, paddingLeft: 12)
        
        checkImageView.centerY(in: self.contentView, right: self.contentView.rightAnchor, paddingRight: 16, width: 24, height: 24)
    }
}
