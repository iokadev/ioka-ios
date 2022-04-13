//
//  Colors.swift
//  Ioka
//
//  Created by ablai erzhanov on 08.04.2022.
//

import UIKit

internal var colors: Colors!

public struct Colors {
    public var primary: UIColor
    public var secondary: UIColor
    public var error: UIColor
    public var success: UIColor
    public var text: UIColor
    public var nonadaptableText: UIColor
    public var divider: UIColor
    public var background: UIColor
    public var secondaryBackground: UIColor
    public var tertiaryBackground: UIColor
    public var quaternaryBackground: UIColor
    public var foreground: UIColor
    public var grey: UIColor
}

extension Colors {
    static public var `default` = Colors(
        primary: UIColor(named: "Primary", in: IokaBundle.bundle, compatibleWith: nil)!,
        secondary: UIColor(named: "Secondary", in: IokaBundle.bundle, compatibleWith: nil)!,
        error: UIColor(named: "Error", in: IokaBundle.bundle, compatibleWith: nil)!,
        success: UIColor(named: "Success", in: IokaBundle.bundle, compatibleWith: nil)!,
        text: UIColor(named: "Text", in: IokaBundle.bundle, compatibleWith: nil)!,
        nonadaptableText: UIColor(named: "NonadaptableText", in: IokaBundle.bundle, compatibleWith: nil)!,
        divider: UIColor(named: "Divider", in: IokaBundle.bundle, compatibleWith: nil)!,
        background: UIColor(named: "Background", in: IokaBundle.bundle, compatibleWith: nil)!,
        secondaryBackground: UIColor(named: "SecondaryBackground", in: IokaBundle.bundle, compatibleWith: nil)!,
        tertiaryBackground: UIColor(named: "TertiaryBackground", in: IokaBundle.bundle, compatibleWith: nil)!,
        quaternaryBackground: UIColor(named: "QuaternaryBackground", in: IokaBundle.bundle, compatibleWith: nil)!,
        foreground: UIColor(named: "Foreground", in: IokaBundle.bundle, compatibleWith: nil)!,
        grey: UIColor(named: "Grey", in: IokaBundle.bundle, compatibleWith: nil)!)
}


final class IokaBundle {
    static let bundle: Bundle = {
        let myBundle = Bundle(for: IokaBundle.self)

        guard let resourceBundleURL = myBundle.url(
            forResource: "Ioka", withExtension: "bundle")
            else { fatalError("Ioka.bundle not found") }

        guard let resourceBundle = Bundle(url: resourceBundleURL)
            else { fatalError("Cannot access Ioka.bundle") }

        return resourceBundle
    }()
}
