//
//  AppDelegate.swift
//  Ioka
//
//  Created by ablai erzhanov on 05.04.2022.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        Ioka.shared.setup(publicApiKey: "shp_GA9Y41H1EJ_test_public_60e22bb99d75650ad1d3e54064461152cb9a954d43ea4629d6931703d5ef87f8")
        return true
    }
}

