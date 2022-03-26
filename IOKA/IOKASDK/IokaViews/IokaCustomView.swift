//
//  IokaCustomView.swift
//  iOKA
//
//  Created by ablai erzhanov on 12.03.2022.
//

import Foundation
import UIKit


class IokaCustomView: UIView {
 
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(backGroundColor: UIColor? = UIColor.white, cornerRadius: CGFloat = 0) {
        self.init()
        self.backgroundColor = backGroundColor
        self.layer.cornerRadius = cornerRadius
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
