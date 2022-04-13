//
//  IokaTheme.swift
//  IOKA
//
//  Created by ablai erzhanov on 25.03.2022.
//

import UIKit


public struct IokaTheme {
    public static var `default` = IokaTheme(colors: Colors.default)
    var colors: Colors
    var typography: Typography
    
    public init(primaryColor: UIColor, secondaryColor: UIColor) {
        var colors = Colors.default
        colors.primary = primaryColor
        colors.secondary = secondaryColor
        
        self.init(colors: colors)
    }
    
    public init(colors: Colors) {
        self.colors = colors
        self.typography = Typography.default
    }
    
    public init(typography: Typography) {
        self.typography = typography
        self.colors = Colors.default
    }
    
    public init(colors: Colors, typography: Typography) {
        self.colors = colors
        self.typography = typography
    }
}
