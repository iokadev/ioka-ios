//
//  AppDelegate.swift
//  Ioka
//
//  Created by ablai erzhanov on 05.04.2022.
//

import UIKit
import Ioka

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // Override point for customization after application launch.
        Ioka.shared.setup(apiKey: "shp_3QMBG27PK2_live_public_84bc91a9abd7abf43750cdc50e3d0ccb6a0b42ec2c7c8898c504b83708446015", locale: Locale.current.toIokaLocale(), applePayConfiguration: ApplePayConfiguration(merchantName: "Ioka", merchantIdentifier: "merchant.kz.ioka.aselya", countryCode: "KZ"))
        return true
    }
}

