//
//  IokaTheme.swift
//  IOKA
//
//  Created by ablai erzhanov on 25.03.2022.
//

import UIKit

internal var cornerRadius = Ioka.shared.theme.cornerRadius

public enum Theme {
    case defaultTheme
    case custom(colors: Colors? = Colors.defaultTheme,
                cornerRadius: CGFloat? = 12,
                typography: Typography? = Typography.defaultFonts)
}

extension Theme {
    
    var colors: Colors {
        switch self {
        case .defaultTheme:
            return Colors.defaultTheme
        case .custom(let colors, _, _):
            if let colors = colors {
                return colors
            } else {
               return Colors.defaultTheme
            }
        }
    }
    
    var cornerRadius: CGFloat {
        switch self {
        case .defaultTheme:
            return 12
        case .custom(_, let cornerRadius, _):
            if let cornerRadius = cornerRadius {
                return cornerRadius
            } else {
                return 12
            }
        }
    }
    
    var typography: Typography {
        switch self {
        case .defaultTheme:
            return Typography.defaultFonts
        case .custom( _, _, let typography):
            if let typography = typography {
                return typography
            } else {
                return Typography.defaultFonts
            }
        }
    }
}

