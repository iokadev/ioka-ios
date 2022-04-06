//
//  SetupInput.swift
//  Ioka
//
//  Created by ablai erzhanov on 05.04.2022.
//

import Foundation

struct Theme {
    var colors: IokaColors
}


struct SetupInput {
  let apiKey: APIKey
//  let applePayConfiguration: ApplePayConfiguration
    let theme: Theme
}
