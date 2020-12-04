//
//  AppDelegate.swift
//  PikabuApp
//
//  Created by Philip Dolenko on 02.12.2020.
//  Copyright © 2020 Philip Dolenko. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        
        let storage = LocalStorageService()
        let networking = NetworkingService()
        
        let feedVC = FeedVC()
        
        feedVC.viewModel = FeedViewModel(localStorageService: storage, networkingService: networking)
        
        window?.rootViewController = feedVC
        window?.makeKeyAndVisible()
        
        return true
    }
}

