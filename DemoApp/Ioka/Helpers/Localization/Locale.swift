//
//  Locale.swift
//  IokaDemoApp
//
//  Created by Тимур Табынбаев on 13.04.2022.
//

import Foundation
import Ioka

internal enum Locale: String, CaseIterable {
    case ru, kk
    
    var label: String {
        switch self {
        case .ru:
            return "Русский"
        case .kk:
            return "Қазақша"
        }
    }
    
    private static var userDefaultsKey = "locale.demoapp.ioka"
    
    static var current: Locale {
        get {
            Locale(rawValue: UserDefaults.standard.string(forKey: Self.userDefaultsKey) ?? "") ?? .ru
        }
        set {
            UserDefaults.standard.set(newValue.rawValue, forKey: Self.userDefaultsKey)
        }
    }
}

extension Locale {
    func toIokaLocale() -> IokaLocale {
        switch self {
        case .ru:
            return .ru
        case .kk:
            return .kk
        }
    }
}
