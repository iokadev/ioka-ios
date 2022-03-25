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
    var fill0: UIColor
    var fill1: UIColor
    var fill2: UIColor
    var fill3: UIColor
    var fill4: UIColor
    var fill5: UIColor
    var fill6: UIColor
    var fill7: UIColor
    var primary: UIColor
    var secondary: UIColor
    var error: UIColor
    var success: UIColor
    var grey: UIColor
}

extension IokaColors {
    static var defaultTheme = IokaColors(fill0: UIColor(named: "Fill0")!, fill1: UIColor(named: "Fill1")!, fill2: UIColor(named: "Fill2")!, fill3: UIColor(named: "Fill3")!, fill4: UIColor(named: "Fill4")!, fill5: UIColor(named: "Fill5")!, fill6: UIColor(named: "Fill6")!, fill7: UIColor(named: "Fill7")!, primary: UIColor(named: "Primary")!, secondary: UIColor(named: "Secondary")!, error: UIColor(named: "Error")!, success: UIColor(named: "Success")!, grey: UIColor(named: "Grey")!)
}

