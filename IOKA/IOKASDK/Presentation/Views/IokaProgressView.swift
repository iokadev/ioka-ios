//
//  IokaIndicatorView.swift
//  IOKA
//
//  Created by ablai erzhanov on 03.04.2022.
//

import Foundation
import UIKit


class IokaProgressView2: UIView {
    
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
        let frame = self.frame
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


class IokaProgressView: UIView {
    
    let color: UIColor
    let lineWidth: CGFloat
    
    private lazy var shapeLayer: ProgressShapeLayer = {
        return ProgressShapeLayer(strokeColor: color, lineWidth: lineWidth)
    }()
    
    init(frame: CGRect, color: UIColor = IOKA.shared.theme.secondary, lineWidth: CGFloat = 6) {
        self.color = color
        self.lineWidth = lineWidth
        
        super.init(frame: frame)
        
        self.backgroundColor = .clear
    }
    
    convenience init(color: UIColor = IOKA.shared.theme.secondary, lineWidth: CGFloat = 6) {
        self.init(frame: .zero, color: color, lineWidth: lineWidth)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layer.cornerRadius = self.frame.width / 2
        
        let path = UIBezierPath(ovalIn: CGRect(x: 0, y: 0,width: self.bounds.width, height: self.bounds.width)
        )
        shapeLayer.path = path.cgPath
    }
    
    func animateStroke() {
       
//        let startAnimation = StrokeAnimation(
//            type: .start,
//            beginTime: 0.25,
//            fromValue: -Double.pi/ 2,
//            toValue: 1 ,
//            duration: 0.75
//        )
//
//        let endAnimation = StrokeAnimation(
//            type: .end,
//            fromValue: -Double.pi/ 2,
//            toValue: 1 ,
//            duration: 0.75
//        )
        
        let strokeAnimationGroup = CAAnimationGroup()
        strokeAnimationGroup.duration = 1
        strokeAnimationGroup.repeatDuration = .infinity
        strokeAnimationGroup.animations = []
       
        shapeLayer.add(strokeAnimationGroup, forKey: nil)
        self.layer.addSublayer(shapeLayer)
    }
}

class StrokeAnimation: CABasicAnimation {
    
    enum StrokeType {
        case start
        case end
    }
    
    override init() {
        super.init()
    }
    
    init(type: StrokeType, beginTime: Double = 0.0, fromValue: CGFloat,toValue: CGFloat, duration: Double) {
        super.init()
        self.keyPath = type == .start ? "strokeStart" : "strokeEnd"
        self.beginTime = beginTime
        self.fromValue = fromValue
        self.toValue = toValue
        self.duration = duration
        self.timingFunction = .init(name: .easeInEaseOut)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class ProgressShapeLayer: CAShapeLayer {
    
    public init(strokeColor: UIColor, lineWidth: CGFloat) {
        super.init()
        self.strokeColor = strokeColor.cgColor
        self.lineWidth = lineWidth
        self.fillColor = UIColor.clear.cgColor
        self.lineCap = .round
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
