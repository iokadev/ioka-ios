//
//  IokaTheme.swift
//  IOKA
//
//  Created by ablai erzhanov on 25.03.2022.
//

import UIKit

/// Сущность для кастомизации интерфейса ioka SDK
public struct IokaTheme {
    public static var `default` = IokaTheme(colors: Colors.default)
    var colors: Colors
    var typography: Typography
    
    /// Упрощенный способ кастомизации. Скорее всего, в оба параметра вам нужно будет передать один цвет -
    /// акцентный цвет своего проекта.
    /// - Parameters:
    ///   - primaryColor: Акцентный цвет
    ///   - secondaryColor: Вторичный акцентный цвет
    public init(primaryColor: UIColor, secondaryColor: UIColor) {
        var colors = Colors.default
        colors.primary = primaryColor
        colors.secondary = secondaryColor
        
        self.init(colors: colors)
    }
    
    /// Кастомизация цветов. Шрифты в этом случае не кастомизируются - используется Typography.default.
    /// - Parameter colors: Можно скопировать Colors.default и изменить только нужные цвета либо создать
    /// объект Colors, передав все цвета
    public init(colors: Colors) {
        self.colors = colors
        self.typography = Typography.default
    }
    
    /// Кастомизация шрифтов. Цвета в этом случае не кастомизируются - используется Colors.default.
    /// - Parameter typography: Можно скопировать Typography.default и изменить только нужные шрифты либо создать
    /// объект Typography, передав все шрифты
    public init(typography: Typography) {
        self.typography = typography
        self.colors = Colors.default
    }
    
    /// Кастомизация цветов и шрифтов
    /// - Parameters:
    ///   - colors: Можно скопировать Colors.default и изменить только нужные цвета либо создать
    /// объект Colors, передав все цвета
    ///   - typography: Можно скопировать Typography.default и изменить только нужные шрифты либо создать
    /// объект Typography, передав все шрифты
    public init(colors: Colors, typography: Typography) {
        self.colors = colors
        self.typography = typography
    }
}
