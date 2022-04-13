//
//  Typography.swift
//  iOKA
//
//  Created by ablai erzhanov on 28.02.2022.
//

import Foundation
import UIKit

internal var typography = Ioka.shared.theme.typography

public struct Typography {
    public var heading: UIFont
    public var heading2: UIFont
    public var title: UIFont
    public var bodySemibold: UIFont
    public var body: UIFont
    public var subtitle: UIFont
    public var subtitleSemiBold: UIFont
    public var subtitleSmall: UIFont
}

public extension Typography {
    static var defaultFonts = Typography(heading: UIFont.systemFont(ofSize: 28, weight: .semibold),
                                             heading2: UIFont.systemFont(ofSize: 24, weight: .regular),
                                             title: UIFont.systemFont(ofSize: 18, weight: .semibold),
                                             bodySemibold: UIFont.systemFont(ofSize: 16, weight: .semibold),
                                             body: UIFont.systemFont(ofSize: 16, weight: .regular),
                                             subtitle: UIFont.systemFont(ofSize: 14, weight: .regular),
                                             subtitleSemiBold: UIFont.systemFont(ofSize: 14, weight: .semibold),
                                             subtitleSmall: UIFont.systemFont(ofSize: 12, weight: .regular))
}
