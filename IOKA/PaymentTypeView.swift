//
//  PaymentTypeView.swift
//  IOKA
//
//  Created by ablai erzhanov on 13.03.2022.
//

import Foundation
import UIKit



protocol PaymentTypeViewDelegate: NSObject {
    func confirmButtonWasPressed(_ orderView: UIView)
}

class PaymentTypeView: UIView {
    

    weak var delegate: PaymentTypeViewDelegate?
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupActions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupActions() {
       
    }
    
    @objc private func handleConfirmButton() {
        delegate?.confirmButtonWasPressed(self)
    }
    
    private func configureView() {
        
    }
    
    private func setupUI() {

        self.backgroundColor = CustomColors.fill5
        [].forEach{ self.addSubview($0) }
        
        
    }
}

