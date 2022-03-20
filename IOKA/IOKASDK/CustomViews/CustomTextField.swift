//
//  CustomTextField.swift
//  iOKA
//
//  Created by ablai erzhanov on 27.02.2022.
//

import Foundation
import UIKit

enum CustomTextFieldState {
    case startTyping
    case wrongInputData
    case correctInputData
    case nonActive
}



class CustomTextField: UITextField {
    
    private var textPadding = UIEdgeInsets(top: 18, left: 16, bottom: 18, right: -240)
    var placeHolderType: TextFieldPlaceHolders?
    var customTextFieldState = CustomTextFieldState.nonActive {
        didSet {
            checkInputData()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.textColor = CustomColors.fill2
        self.backgroundColor = CustomColors.fill4
        self.layer.cornerRadius = 12
        self.layer.borderWidth = 1
        self.layer.borderColor = CustomColors.fill1!.cgColor

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
            self.placeholder = TextFieldPlaceHolders.cardNumber.rawValue
        case .dateExpiration:
            self.placeholder = TextFieldPlaceHolders.dateExpiration.rawValue
        case .cvv:
            self.placeholder = TextFieldPlaceHolders.cvv.rawValue
            self.isSecureTextEntry = true
        }
    }
    
    func checkInputData() {
        switch customTextFieldState {
        case .startTyping:
            self.layer.borderColor = CustomColors.primary?.cgColor
        case .wrongInputData:
            self.layer.borderColor = CustomColors.error?.cgColor
        case .nonActive:
            self.layer.borderColor = CustomColors.fill1?.cgColor
        case .correctInputData:
            self.layer.borderColor = CustomColors.fill1?.cgColor
        }
    }
}

extension CustomTextField {
    func setBrandIcon(_ image: UIImage, isCardBrendSetted: Bool) {
        guard !isCardBrendSetted else { return }
        
        
    }
}
