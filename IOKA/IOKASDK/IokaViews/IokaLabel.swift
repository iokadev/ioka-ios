//
//  CustomLabel.swift
//  iOKA
//
//  Created by ablai erzhanov on 28.02.2022.
//

import Foundation
import UIKit



class IokaLabel: UILabel {
    
    var title: String?
    var iokaFont: UIFont?
    var iokaTextColor: UIColor?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(title: String? = nil, iokaFont: UIFont? = nil, iokaTextColor: UIColor? = nil, iokaTextAlignemnt: NSTextAlignment? = nil) {
        self.init(frame: CGRect())
        self.title = title
        self.iokaFont = iokaFont
        self.iokaTextColor = iokaTextColor
        self.textAlignment = iokaTextAlignemnt ?? .left
        setupLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLabel() {
        self.text = title
        self.textColor = iokaTextColor
        self.font = iokaFont
        self.numberOfLines = 0
    }
}
