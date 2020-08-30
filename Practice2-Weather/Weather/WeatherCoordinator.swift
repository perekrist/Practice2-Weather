//
//  WeatherCoordinator.swift
//  Practice2-Weather
//
//  Created by Кристина Перегудова on 16.08.2020.
//  Copyright © 2020 Кристина Перегудова. All rights reserved.
//

import UIKit

protocol WeatherCoordinatorDelegate: class {
    func didFinish(from coordinator: WeatherCoordinator)
}

class WeatherCoordinator: Coordinator {
    weak var delegate: WeatherCoordinatorDelegate?
    let rootViewController: UINavigationController
    let city: String
    
    init(rootViewController: UINavigationController, city: String) {
        self.rootViewController = rootViewController
        self.city = city
    }
    
    override func start() {
        let weatherViewModel = WeatherViewModel(city: city)
        weatherViewModel.delegate = self
        let weatherViewController = WeatherViewController(viewModel: weatherViewModel)
        rootViewController.pushViewController(weatherViewController, animated: true)
    }
    
    override func finish() {
        delegate?.didFinish(from: self)
    }
}

extension WeatherCoordinator: WeatherViewModelDelegate {
    func weatherViewModelDidFinish(_ viewModel: WeatherViewModel) {
        finish()
    }
}
