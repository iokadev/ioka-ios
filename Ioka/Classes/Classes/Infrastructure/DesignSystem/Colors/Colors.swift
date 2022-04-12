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


//extension Colors {
//    static public var defaultTheme = Colors(nonadaptableText: UIColor(named: "nonadaptableText")!, background: UIColor(named: "Background")!, text: UIColor(named: "Text")!, divider: UIColor(named: "Divider")!, fill4: UIColor(named: "Fill4")!, secondaryBackground: UIColor(named: "SecondaryBackground")!, tertiaryBackground: UIColor(named: "TertiaryBackground")!, foreground: UIColor(named: "Foreground")!, primary: UIColor(named: "Primary")!, secondary: UIColor(named: "Secondary")!, error: UIColor(named: "Error")!, success: UIColor(named: "Success")!, grey: UIColor(named: "Grey")!)
//}

extension Colors {
    static public var defaultTheme = Colors(
        nonadaptableText: UIColor(named: "nonadaptableText", in: IokaBundle.bundle, compatibleWith: nil)!,
        background: UIColor(named: "Background", in: IokaBundle.bundle, compatibleWith: nil)!,
        text: UIColor(named: "Text", in: IokaBundle.bundle, compatibleWith: nil)!,
        divider: UIColor(named: "Divider", in: IokaBundle.bundle, compatibleWith: nil)!,
        fill4: UIColor(named: "Fill4", in: IokaBundle.bundle, compatibleWith: nil)!,
        secondaryBackground: UIColor(named: "SecondaryBackground", in: IokaBundle.bundle, compatibleWith: nil)!,
        tertiaryBackground: UIColor(named: "TertiaryBackground", in: IokaBundle.bundle, compatibleWith: nil)!,
        foreground: UIColor(named: "Foreground", in: IokaBundle.bundle, compatibleWith: nil)!,
        primary: UIColor(named: "Primary", in: IokaBundle.bundle, compatibleWith: nil)!,
        secondary: UIColor(named: "Secondary", in: IokaBundle.bundle, compatibleWith: nil)!,
        error: UIColor(named: "Error", in: IokaBundle.bundle, compatibleWith: nil)!,
        success: UIColor(named: "Success", in: IokaBundle.bundle, compatibleWith: nil)!,
        grey: UIColor(named: "Grey", in: IokaBundle.bundle, compatibleWith: nil)!)
}


final class IokaBundle {
   
    static let bundle: Bundle = {
        
        guard let bundle = Bundle(identifier: "Ioka") else { return Bundle(for: IokaBundle.self)}

        return bundle
    }()
}

