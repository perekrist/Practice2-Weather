//
//  WeatherCoordinator.swift
//  Practice2-Weather
//
//  Created by Кристина Перегудова on 16.08.2020.
//  Copyright © 2020 Кристина Перегудова. All rights reserved.
//

import UIKit

class WeatherCoordinator: Coordinator {
    let rootViewController: UINavigationController
    
    init(rootViewController: UINavigationController) {
        self.rootViewController = rootViewController
    }
    
    override func start() {
        let weatherViewModel = WeatherViewModel()
        let weatherViewController = WeatherViewController(viewModel: weatherViewModel)
        rootViewController.setViewControllers([weatherViewController], animated: false)
    }
}
