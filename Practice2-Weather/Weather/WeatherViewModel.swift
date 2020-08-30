//
//  WeatherViewModel.swift
//  Practice2-Weather
//
//  Created by Кристина Перегудова on 16.08.2020.
//  Copyright © 2020 Кристина Перегудова. All rights reserved.
//

import UIKit
import SVProgressHUD

protocol WeatherViewModelDelegate: class {
    func weatherViewModelDidFinish(_ viewModel: WeatherViewModel)
}

class WeatherViewModel {
    weak var delegate: WeatherViewModelDelegate?
    
    var error = ""
    let cityName: String
    
    var weatherForecast: Weather?
    
    var apiService: NetworkingService?
    
    var onDidUpdate: (() -> Void)?
    var onDidError: (() -> Void)?
    
    init(city: String) {
        self.cityName = city
        apiService = NetworkingService()
    }
    
    func getWeather() {
        SVProgressHUD.show()
        apiService!.getWeatherByCity(city: cityName) { result in
            switch result {
            case .success(let weather):
                SVProgressHUD.dismiss()
                self.weatherForecast = weather
                self.onDidUpdate?()
            case .failure(let error):
                SVProgressHUD.dismiss()
                self.error = error.localizedDescription
                self.onDidError?()
            }
        }
    }
    
    func compassDirection(for deg: Double) -> String {
        if deg < 0 { return "Wind direction error" }
        let directions = ["N", "NE", "E", "SE", "S", "SW", "W", "NW"]
        let index = Int((deg + 22.5) / 45.0) & 7
        return directions[index]
    }
    
    func goBack() {
        delegate?.weatherViewModelDidFinish(self)
    }
}
