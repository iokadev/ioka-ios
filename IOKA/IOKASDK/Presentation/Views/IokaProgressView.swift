//
//  IokaIndicatorView.swift
//  IOKA
//
//  Created by ablai erzhanov on 03.04.2022.
//

import Foundation
import UIKit


class IokaProgressView: UIView {
    
    let color: UIColor
    let lineWidth: CGFloat
    
    private lazy var shapeLayer = CAShapeLayer()
    
    override init(frame: CGRect) {
        self.color = IOKA.shared.theme.secondary
        self.lineWidth = 6
        super.init(frame: frame)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func startIndicator() {
        self.layer.addSublayer(shapeLayer)
        let frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        let circularPath = UIBezierPath(arcCenter: CGPoint(x: frame.size.width / 2, y: frame.size.height / 2), radius: 40, startAngle: -CGFloat.pi/2, endAngle: 2 * CGFloat.pi, clockwise: true)
        shapeLayer.path = circularPath.cgPath
        shapeLayer.strokeColor = color.cgColor
        shapeLayer.lineWidth = lineWidth
        shapeLayer.lineCap = CAShapeLayerLineCap.round
        shapeLayer.strokeEnd = 0
        shapeLayer.fillColor = UIColor.clear.cgColor
        
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        basicAnimation.toValue = 1
        basicAnimation.duration = 0.6
        basicAnimation.fillMode = CAMediaTimingFillMode.forwards
        basicAnimation.isRemovedOnCompletion = false
        basicAnimation.repeatDuration = .infinity
        shapeLayer.add(basicAnimation, forKey: "animation")
        
    }
    
    func stopIndicator() {
        shapeLayer.removeFromSuperlayer()
    }
}
