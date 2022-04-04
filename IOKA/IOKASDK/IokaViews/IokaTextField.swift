//
//  IokaTextField.swift
//  iOKA
//
//  Created by ablai erzhanov on 27.02.2022.
//

import Foundation
import UIKit

enum IokaTextFieldState {
    case startTyping
    case wrongInputData
    case correctInputData
    case nonActive
}



class IokaTextField: UITextField {
    
    private var textPadding = UIEdgeInsets(top: 18, left: 16, bottom: 18, right: -240)
    var placeHolderType: TextFieldPlaceHolders?
    var iokaTextFieldState = IokaTextFieldState.nonActive {
        didSet {
            checkInputData()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.textColor = IOKA.shared.theme.text
        self.backgroundColor = IOKA.shared.theme.fill4
        self.layer.cornerRadius = 12
        self.layer.borderWidth = 1
        self.layer.borderColor = IOKA.shared.theme.background.cgColor

    }
    
    convenience init(placeHolderType: TextFieldPlaceHolders) {
        self.init(frame: CGRect())
        self.placeHolderType = placeHolderType
        setTextField()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.textRect(forBounds: bounds)
        return rect.inset(by: textPadding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.textRect(forBounds: bounds)
        return rect.inset(by: textPadding)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.textRect(forBounds: bounds)
        return rect.inset(by: textPadding)
    }
    
    func setTextField() {
        
        guard let placeHolderType = placeHolderType else { return }
        self.keyboardType = .numberPad
        
        switch placeHolderType {
        case .cardNumber:
            self.placeholder = IokaLocalizable.enterCardNumber
        case .dateExpiration:
            self.placeholder = IokaLocalizable.cardExpiration
        case .cvv:
            self.placeholder = IokaLocalizable.cvv
            self.isSecureTextEntry = true
        }
    }
    
    func checkInputData() {
        switch iokaTextFieldState {
        case .startTyping:
            self.layer.borderColor = IOKA.shared.theme.primary.cgColor
        case .wrongInputData:
            self.layer.borderColor = IOKA.shared.theme.error.cgColor
        case .nonActive:
            self.layer.borderColor = IOKA.shared.theme.background.cgColor
        case .correctInputData:
            self.layer.borderColor = IOKA.shared.theme.background.cgColor
        }
    }
}
