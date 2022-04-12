//
//  IOKAConstraints.swift
//  IOKA
//
//  Created by ablai erzhanov on 22.03.2022.
//

import UIKit


internal extension UIView {
    func anchor(top: NSLayoutYAxisAnchor? = nil,
                left: NSLayoutXAxisAnchor? = nil,
                bottom: NSLayoutYAxisAnchor? = nil,
                right: NSLayoutXAxisAnchor? = nil,
                paddingTop: CGFloat = 0,
                paddingLeft: CGFloat = 0,
                paddingBottom: CGFloat = 0,
                paddingRight: CGFloat = 0,
                width: CGFloat? = nil,
                height: CGFloat? = nil) {
        
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
        }
        
        if let left = left {
            leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
        }
        
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom).isActive = true
        }
        
        if let right = right {
            rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
        }
        
        setDimensions(width: width, height: height)
    }
    
    func center(in viewX: UIView, in viewY: UIView, width: CGFloat? = nil, height: CGFloat? = nil) {
        translatesAutoresizingMaskIntoConstraints = false
        centerXAnchor.constraint(equalTo: viewX.centerXAnchor).isActive = true
        centerYAnchor.constraint(equalTo: viewY.centerYAnchor).isActive = true
        setDimensions(width: width, height: height)
    }
    
    func centerX(in view: UIView, top: NSLayoutYAxisAnchor? = nil, paddingTop: CGFloat? = nil, bottom: NSLayoutYAxisAnchor? = nil, paddingBottom: CGFloat? = nil, width: CGFloat? = nil, height: CGFloat? = nil) {
        translatesAutoresizingMaskIntoConstraints = false
        centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        if let top = top, let paddingTop = paddingTop {
            topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
        }
        
        if let bottom = bottom, let paddingBottom = paddingBottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom).isActive = true
        }
        
        setDimensions(width: width, height: height)
    }
    
    func centerY(in view: UIView, left: NSLayoutXAxisAnchor? = nil, paddingLeft: CGFloat? = nil, right: NSLayoutXAxisAnchor? = nil, paddingRight: CGFloat? = nil, width: CGFloat? = nil, height: CGFloat? = nil) {
        translatesAutoresizingMaskIntoConstraints = false
        centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        if let left = left, let paddingLeft = paddingLeft {
            leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
        }
        if let right = right, let paddingRight = paddingRight {
            rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
        }
        
        setDimensions(width: width, height: height)
    }
    
    func setDimensions(width: CGFloat? = nil, height: CGFloat? = nil) {
        translatesAutoresizingMaskIntoConstraints = false
        if let width = width {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        
        if let height = height {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
    
    func fillView( _ view: UIView?) {
        guard let view = view else { return }

        translatesAutoresizingMaskIntoConstraints = false
        
        anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor)
    }
    
    func deactivateConstraints() {
        for constraint in self.constraints {
            constraint.isActive = false
        }
    }
    
    func removeConstraints() {
        for constraint in self.constraints {
            self.removeConstraint(constraint)
        }
        
    }
}
