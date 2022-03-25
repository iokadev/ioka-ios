//
//  CustomStackView.swift
//  iOKA
//
//  Created by ablai erzhanov on 02.03.2022.
//

import Foundation
import UIKit


class IokaStackView: UIStackView {
   
    var views: [UIView] = []
    var viewsDistribution: UIStackView.Distribution = .equalSpacing
    var viewsAxis: NSLayoutConstraint.Axis = .horizontal
    var viewsSpacing: CGFloat = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(views: [UIView] = [], viewsDistribution: UIStackView.Distribution = .equalSpacing, viewsAxis:  NSLayoutConstraint.Axis = .horizontal, viewsSpacing: CGFloat = 0) {
        self.init(frame: CGRect())
        self.views = views
        self.viewsAxis = viewsAxis
        self.viewsSpacing = viewsSpacing
        self.viewsDistribution = viewsDistribution
        setUpStackView()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpStackView() {
        self.views.forEach{ self.addArrangedSubview($0) }
        self.spacing = viewsSpacing
        self.axis = viewsAxis
        self.distribution = viewsDistribution
    }
}
