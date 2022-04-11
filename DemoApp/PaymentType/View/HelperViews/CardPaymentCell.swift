//
//  CardPaymentCell.swift
//  IOKA
//
//  Created by ablai erzhanov on 25.03.2022.
//


import Foundation
import UIKit

internal protocol CardPaymentCellDelegate: NSObject {
    func handleViewTap(_ view: CardPaymentCell, isPayWithCashSelected: Bool, cardResponse: SavedCardDTO)
}

internal class CardPaymentCell: UITableViewCell {
    static let cellId = "CardPaymentCell"
    
    let cardBrandImageView = UIImageView()
    let panMaskedLabel = IokaLabel( title: "Apple pay", iokaFont: typography.body, iokaTextColor: DemoAppColors.text)
    let checkImageView = IokaImageView(imageName: "uncheckIcon")
    var isViewSelected: Bool = false
    weak var delegate: CardPaymentCellDelegate?
    private var cardResponse: SavedCardDTO?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setActions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(model: SavedCardDTO, delegate: CardPaymentCellDelegate) {
        self.delegate = delegate
        self.cardResponse = model
        self.panMaskedLabel.text = model.pan_masked.trimPanMasked()
        guard let paymentSystem = model.payment_system else { return }
        self.cardBrandImageView.image = UIImage(named: paymentSystem)
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
        guard let cardResponse = cardResponse else { return }

        self.isViewSelected.toggle()
        changeViewSelection()
        delegate?.handleViewTap(self, isPayWithCashSelected: isViewSelected, cardResponse: cardResponse)
    }
    
    private func setupUI() {
        self.backgroundColor = DemoAppColors.tertiaryBackground
        self.layer.cornerRadius = 8
        cardBrandImageView.contentMode = .scaleAspectFit
        [cardBrandImageView, panMaskedLabel, checkImageView].forEach{ self.contentView.addSubview($0) }
        
        cardBrandImageView.centerY(in: self, left: self.contentView.leftAnchor, paddingLeft: 16, width: 24, height: 24)
        
        panMaskedLabel.centerY(in: self, left: cardBrandImageView.rightAnchor, paddingLeft: 12)
        
        checkImageView.centerY(in: self, right: self.contentView.rightAnchor, paddingRight: 16, width: 24, height: 24)
    }
}