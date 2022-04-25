//
//  File.swift
//  CreditCardValidator
//
//  Created by ablai erzhanov on 25.04.2022.
//

import UIKit

internal class TooltipView: UIView {
    
    var roundRect:CGRect!
    let toolTipWidth : CGFloat = 20.0
    let toolTipHeight : CGFloat = 10.0
    let titleLabel = IokaLabel(title: IokaLocalizable.cvvExplained, iokaFont: typography.subtitleSmall, iokaTextColor: colors.background)
    let cardImageView = IokaImageView(imageName: "cardBackground")
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        self.alpha = 0.0
        titleLabel.adjustsFontForContentSizeCategory = true
    }
    

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        drawToolTip(rect)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func performShow() {
        UIView.animate(withDuration: 0.5) {
            self.alpha = 1.0
        }
    }
    
    public func performDismiss() {
        self.alpha = 0.0
    }
    
    private func drawToolTip(_ rect : CGRect){
       roundRect = CGRect(x: rect.minX, y: rect.minY, width: rect.width, height: rect.height - toolTipHeight)
       let roundRectBez = UIBezierPath(roundedRect: roundRect, cornerRadius: 8.0)
       let trianglePath = createTriangleTipPath()
       roundRectBez.append(trianglePath)
       let shape = createShapeLayer(roundRectBez.cgPath)
       self.layer.insertSublayer(shape, at: 0)
    }
    
    private func createTriangleTipPath() -> UIBezierPath{
        let tooltipRect = CGRect(x: roundRect.maxX - 38, y: roundRect.maxY, width: toolTipWidth, height: toolTipHeight)
       let trianglePath = UIBezierPath()
       trianglePath.move(to: CGPoint(x: tooltipRect.minX, y: tooltipRect.minY))
       trianglePath.addLine(to: CGPoint(x: tooltipRect.maxX, y: tooltipRect.minY))
       trianglePath.addLine(to: CGPoint(x: tooltipRect.midX, y: tooltipRect.maxY))
       trianglePath.addLine(to: CGPoint(x: tooltipRect.minX, y: tooltipRect.minY))
       trianglePath.close()
       return trianglePath
    }
    
    private func createShapeLayer(_ path : CGPath) -> CAShapeLayer{
        let shape = CAShapeLayer()
        shape.path = path
        shape.fillColor = colors.text.cgColor
        shape.shadowOffset = CGSize(width: 0, height: 2)
        shape.shadowRadius = 8.0
        shape.shadowOpacity = 0.4
        return shape
    }
    
    private func setUI() {
        [cardImageView, titleLabel].forEach { addSubview($0) }
        
        cardImageView.anchor(top: self.topAnchor, left: self.leftAnchor, paddingTop: 12, paddingLeft: 12, width: 40, height: 24)
       
        titleLabel.anchor(top: self.topAnchor, left: cardImageView.rightAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, paddingTop: 12, paddingLeft: 12, paddingBottom: 22, paddingRight: 12)
    }
}
