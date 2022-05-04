//
//  PartialTransparentView.swift
//  Ioka
//
//  Created by ablai erzhanov on 29.04.2022.
//

import UIKit


// MARK: - Class PartialTransparentView
internal class PartialTransparentView: UIView {
    var rectsArray: [CGRect]?
    let shapeLayer = CAShapeLayer()

    convenience init(rectsArray: [CGRect]) {
        self.init()

        self.rectsArray = rectsArray

        backgroundColor = UIColor.black.withAlphaComponent(0.6)
        isOpaque = false
    }

    override func draw(_ rect: CGRect) {
        backgroundColor?.setFill()
        UIRectFill(rect)

        guard let rectsArray = rectsArray else {
            return
        }

        for holeRect in rectsArray {
            let path = UIBezierPath(roundedRect: holeRect, cornerRadius: 16)

            let holeRectIntersection = rect.intersection(holeRect)

            UIRectFill(holeRectIntersection)

            UIColor.clear.setFill()
            UIGraphicsGetCurrentContext()?.setBlendMode(CGBlendMode.copy)
            path.fill()
        }
    }


    func createBorderForRect() {
        guard let rectsArray = rectsArray else { return }

        for holeRect in rectsArray {
            let frameSize = holeRect.size
            let shapeRect = CGRect(x: holeRect.minX, y: holeRect.minY, width: frameSize.width, height: frameSize.height)

            shapeLayer.bounds = shapeRect
            shapeLayer.position = CGPoint(x: self.frame.width / 2, y: holeRect.minY + holeRect.height / 2)
            shapeLayer.fillColor = UIColor.clear.cgColor
            shapeLayer.strokeColor = colors.success.cgColor
            shapeLayer.lineWidth = 4
            shapeLayer.path = UIBezierPath(roundedRect: shapeRect, cornerRadius: 16).cgPath

            self.layer.addSublayer(shapeLayer)
        }
    }

    func removeBorderForRect() {
        shapeLayer.removeFromSuperlayer()
    }
}

