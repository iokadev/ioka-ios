//
//  CustomTextField.swift
//  iOKA
//
//  Created by ablai erzhanov on 27.02.2022.
//

import Foundation
import UIKit

internal class IokaTextField: UITextField {
    internal enum State {
        case active
        case inactive
        case invalid
    }
    
    internal enum InputType: String {
        case cardNumber
        case dateExpiration
        case cvv
    }
    
    private var textPadding = UIEdgeInsets(top: 18, left: 16, bottom: 18, right: -240)
    
    let inputType: InputType
    var iokaState = IokaTextField.State.inactive {
        didSet {
            updateBorderColor()
        }
    }
    
    init(inputType: InputType) {
        self.inputType = inputType
        
        super.init(frame: .zero)
        
        self.textColor = colors.text
        self.backgroundColor = colors.secondaryBackground
        self.layer.cornerRadius = 12
        self.layer.borderWidth = 1
        
        updateBorderColor()
        setupTextField()
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
    
    func setupTextField() {
        self.keyboardType = .numberPad
        
        switch inputType {
        case .cardNumber:
            self.placeholder = IokaLocalizable.enterCardNumber
            self.textContentType = .creditCardNumber
        case .dateExpiration:
            self.placeholder = IokaLocalizable.cardExpiration
        case .cvv:
            self.placeholder = IokaLocalizable.cvv
            self.isSecureTextEntry = true
        }
    }
    
    func updateBorderColor() {
        switch iokaState {
        case .active:
            self.layer.borderColor = colors.primary.cgColor
        case .inactive:
            self.layer.borderColor = colors.background.cgColor
        case .invalid:
            self.layer.borderColor = colors.error.cgColor
        }
    }
}
