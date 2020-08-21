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
    let city: String
    
    init(rootViewController: UINavigationController, city: String) {
        self.rootViewController = rootViewController
        self.city = city
    }
    
    override func start() {
        let weatherViewModel = WeatherViewModel(city: city)
        let weatherViewController = WeatherViewController(viewModel: weatherViewModel)
        rootViewController.pushViewController(weatherViewController, animated: true)
    }
}
