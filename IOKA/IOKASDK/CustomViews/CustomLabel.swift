//
//  CustomLabel.swift
//  iOKA
//
//  Created by ablai erzhanov on 28.02.2022.
//

import Foundation
import UIKit



class CustomLabel: UILabel {
    
    var title: String?
    var customFont: UIFont?
    var customTextColor: UIColor?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(title: String? = nil, customFont: UIFont? = nil, customTextColor: UIColor? = nil, customTextAlignemnt: NSTextAlignment? = nil) {
        self.init(frame: CGRect())
        self.title = title
        self.customFont = customFont
        self.customTextColor = customTextColor
        self.textAlignment = customTextAlignemnt ?? .left
//        self.textAlignment = textAlignment
        setupLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLabel() {
        self.text = title
        self.textColor = customTextColor
        self.font = customFont
        self.numberOfLines = 0
    }
}
