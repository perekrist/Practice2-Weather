//
//  AppDelegate.swift
//  Practice2-Weather
//
//  Created by Кристина Перегудова on 30.07.2020.
//  Copyright © 2020 Кристина Перегудова. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    lazy var appCoordinator: AppCoordinator = makeAppCoordinator()
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        appCoordinator.start()
        
        return true
    }
    
    private func makeAppCoordinator() -> AppCoordinator {
        let window = UIWindow(frame: UIScreen.main.bounds)
        self.window = window
        return AppCoordinator(window: window)
    }
}
