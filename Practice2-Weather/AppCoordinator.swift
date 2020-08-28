//
//  AppCoordinator.swift
//  Practice2-Weather
//
//  Created by Кристина Перегудова on 30.07.2020.
//  Copyright © 2020 Кристина Перегудова. All rights reserved.
//

import UIKit

class AppCoordinator: Coordinator {
    // MARK: - Properties
    let window: UIWindow
    
    let rootViewController: UINavigationController = UINavigationController()
    
    // MARK: - Coordinator
    init(window: UIWindow) {
        self.window = window
    }
    
    override func start() {
        let mapCoordinator = MapCoordinator(rootViewController: rootViewController)
        self.addChildCoordinator(mapCoordinator)
        mapCoordinator.start()
        
        window.rootViewController = rootViewController
        window.makeKeyAndVisible()
    }
    
    override func finish() {
    }
}
