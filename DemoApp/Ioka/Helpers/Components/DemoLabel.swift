//
//  CustomLabel.swift
//  iOKA
//
//  Created by ablai erzhanov on 28.02.2022.
//

import Foundation
import UIKit



internal class DemoLabel: UILabel {
    
    var title: String?
    var demoFont: UIFont?
    var demoTextColor: UIColor?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(title: String? = nil, font: UIFont? = nil, textColor: UIColor? = nil, textAlignment: NSTextAlignment? = nil) {
        self.init()
        self.title = title
        self.demoFont = font
        self.demoTextColor = textColor
        self.textAlignment = textAlignment ?? .left
        setupLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLabel() {
        self.text = title
        self.textColor = demoTextColor
        self.font = demoFont
        self.numberOfLines = 0
    }
}
