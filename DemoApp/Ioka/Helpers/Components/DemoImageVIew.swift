//
//  DemoImageView.swift
//  iOKA
//
//  Created by ablai erzhanov on 02.03.2022.
//

import Foundation
import UIKit


internal class DemoImageView: UIImageView {
    
    var imageName: String? {
        didSet {
           setupImageView()
        }
    }
    var imageTintColor: UIColor?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(imageName: String? = nil, imageTintColor: UIColor? = nil, cornerRadius: CGFloat? = nil) {
        self.init(frame: CGRect())
        self.imageName = imageName
        self.imageTintColor = imageTintColor
        self.layer.cornerRadius = cornerRadius ?? 0
        self.layer.masksToBounds = true
        setupImageView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setupImageView() {
        guard let imageName = imageName else { return }
        if let imageTintColor = imageTintColor {
            self.image = UIImage(named: imageName)?.withRenderingMode(.alwaysTemplate)
            self.tintColor = imageTintColor
        } else {
            self.image = UIImage(named: imageName)
        }
    }
}
