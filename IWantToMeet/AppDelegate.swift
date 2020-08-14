//
//  AppDelegate.swift
//  IWantToMeet
//
//  Created by Rafaela Galdino on 12/08/20.
//  Copyright © 2020 Rafaela Galdino. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = UINavigationController(rootViewController: MapViewController())
        window?.makeKeyAndVisible()
        return true
    }

}

