//
//  IokaTheme.swift
//  IOKA
//
//  Created by ablai erzhanov on 25.03.2022.
//

import UIKit


protocol IokaThemeProtocol {
    var theme: IokaColors { get }
}



enum IokaTheme {
    case defaultTheme
    case customTheme(iokaColors: IokaColors)
    
    var iokaColors: IokaColors {
        switch self {
        case .defaultTheme:
            return IokaColors.defaultTheme
        case .customTheme(let iokaColors):
            return iokaColors
        }
    }
}

struct IokaColors {
    var nonadaptableText: UIColor
    var background: UIColor
    var text: UIColor
    var divider: UIColor
    var fill4: UIColor
    var secondaryBackground: UIColor
    var tertiaryBackground: UIColor
    var foreground: UIColor
    var primary: UIColor
    var secondary: UIColor
    var error: UIColor
    var success: UIColor
    var grey: UIColor
}

extension IokaColors {
    static var defaultTheme = IokaColors(nonadaptableText: UIColor(named: "nonadaptableText")!, background: UIColor(named: "Background")!, text: UIColor(named: "Text")!, divider: UIColor(named: "Divider")!, fill4: UIColor(named: "Fill4")!, secondaryBackground: UIColor(named: "SecondaryBackground")!, tertiaryBackground: UIColor(named: "TertiaryBackground")!, foreground: UIColor(named: "Foreground")!, primary: UIColor(named: "Primary")!, secondary: UIColor(named: "Secondary")!, error: UIColor(named: "Error")!, success: UIColor(named: "Success")!, grey: UIColor(named: "Grey")!)
}

