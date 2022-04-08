//
//  DeleteCardView.swift
//  IOKA
//
//  Created by ablai erzhanov on 30.03.2022.
//

import UIKit

internal protocol DeleteSavedCardViewDelegate: NSObject {
    func closeDeleteSavedCardView(_ view: DeleteSavedCardView)
    func deleteSavedCard(_ view: DeleteSavedCardView)
}

internal class DeleteSavedCardView: UIView {
    
    public weak var delegate: DeleteSavedCardViewDelegate?
    
    private let backGroundView = UIView()
    private let deleteCardImageView = IokaImageView(imageName: "deleteProduct")
    private let title = IokaLabel(iokaFont: typography.title, iokaTextColor: DemoAppColors.text)
    private let deleteCardButton = UIButton()
    private let cancelButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        setActions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configuredeleteCardView(card: GetCardResponse?) {
        guard let card = card else { return }
        self.title.text =  "Вы уверены, что хотите удалить карту \(card.pan_masked.trimPanMasked())?"
    }
    
    private func setActions() {
        deleteCardButton.addTarget(self, action: #selector(deleteCard), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(closeView), for: .touchUpInside)
    }
    
    @objc private func closeView() {
        delegate?.closeDeleteSavedCardView(self)
    }
    
    @objc private func deleteCard() {
        delegate?.deleteSavedCard(self)
    }
    
    private func setUI() {
        self.backgroundColor = DemoAppColors.foreground
        self.addSubview(backGroundView)
        
        backGroundView.layer.cornerRadius = 12
        backGroundView.layer.masksToBounds = true
        backGroundView.backgroundColor = DemoAppColors.background
        backGroundView.centerY(in: self, left: self.leftAnchor, paddingLeft: 40, right: self.rightAnchor, paddingRight: 40)
        
        [deleteCardImageView, title, deleteCardButton, cancelButton].forEach{ backGroundView.addSubview($0) }
        
        cancelButton.setTitle("Отмена", for: .normal)
        deleteCardButton.setTitle("Удалить", for: .normal)
        deleteCardButton.layer.cornerRadius = 12
        deleteCardButton.layer.masksToBounds = true
        deleteCardButton.backgroundColor = DemoAppColors.error
        cancelButton.backgroundColor = .clear
        cancelButton.setTitleColor(.black, for: .normal)
        
        deleteCardImageView.centerX(in: backGroundView, top: backGroundView.topAnchor, paddingTop: 40, width: 56, height: 56)
        title.anchor(left: backGroundView.leftAnchor, right: backGroundView.rightAnchor, paddingLeft: 24, paddingRight: 24)
        title.centerX(in: backGroundView, top: deleteCardImageView.bottomAnchor, paddingTop: 24)
        deleteCardButton.anchor(top: title.bottomAnchor, left: backGroundView.leftAnchor, bottom: backGroundView.bottomAnchor,  right: backGroundView.rightAnchor, paddingTop: 24, paddingLeft: 24, paddingBottom: 68, paddingRight: 24, height: 48)
        cancelButton.anchor(top: deleteCardButton.bottomAnchor,left: backGroundView.leftAnchor, right: backGroundView.rightAnchor, paddingTop: 14,  paddingLeft: 24, paddingRight: 24, height: 48)
    }
}
