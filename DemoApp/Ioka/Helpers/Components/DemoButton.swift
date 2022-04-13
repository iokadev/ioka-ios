//
//  DemoButton.swift
//  iOKA
//
//  Created by ablai erzhanov on 27.02.2022.
//

import Foundation
import UIKit

internal class DemoButton: UIButton {
    var title: String?
    var imageName: String?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(title: String? = nil, imageName: String? = nil, backGroundColor: UIColor? = nil) {
        self.init(frame: CGRect())
        self.title = title
        self.imageName = imageName
        self.backgroundColor = backGroundColor ?? colors.primary
        setupButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    private func setupButton() {
        self.setTitle(title, for: .normal)
        self.layer.cornerRadius = 12
        if let imageName = imageName {
            self.setImage(UIImage(named: imageName), for: .normal)
        }
    }
}
