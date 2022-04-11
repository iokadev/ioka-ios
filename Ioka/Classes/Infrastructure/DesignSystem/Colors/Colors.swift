//
//  Colors.swift
//  Ioka
//
//  Created by ablai erzhanov on 08.04.2022.
//

import UIKit

internal var colors = Ioka.shared.theme.colors

public struct Colors {
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


extension Colors {
    static var defaultTheme = Colors(nonadaptableText: UIColor(named: "nonadaptableText")!, background: UIColor(named: "Background")!, text: UIColor(named: "Text")!, divider: UIColor(named: "Divider")!, fill4: UIColor(named: "Fill4")!, secondaryBackground: UIColor(named: "SecondaryBackground")!, tertiaryBackground: UIColor(named: "TertiaryBackground")!, foreground: UIColor(named: "Foreground")!, primary: UIColor(named: "Primary")!, secondary: UIColor(named: "Secondary")!, error: UIColor(named: "Error")!, success: UIColor(named: "Success")!, grey: UIColor(named: "Grey")!)
}
