//
//  MapCoordinator.swift
//  Practice2-Weather
//
//  Created by Кристина Перегудова on 30.07.2020.
//  Copyright © 2020 Кристина Перегудова. All rights reserved.
//

import UIKit

class MapCoordinator: Coordinator {
    let rootViewController: UINavigationController
    
    init(rootViewController: UINavigationController) {
        self.rootViewController = rootViewController
    }
    
    override func start() {
        let mapViewModel = MapViewModel()
        let mapViewController = MapViewController(viewModel: mapViewModel)
        rootViewController.setViewControllers([mapViewController], animated: false)
    }
}

extension MapCoordinator: MapViewModelDelegate {
    func mapViewModel(_ viewModel: MapViewModel, didRequestShowWeatherFor city: String) {
        let weatherCoordinator = WeatherCoordinator(rootViewController: rootViewController, city: city)
        addChildCoordinator(weatherCoordinator)
        weatherCoordinator.start()
    }
}
