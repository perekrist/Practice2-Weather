//
//  WeatherViewModel.swift
//  Practice2-Weather
//
//  Created by Кристина Перегудова on 16.08.2020.
//  Copyright © 2020 Кристина Перегудова. All rights reserved.
//

import UIKit

protocol WeatherViewModelDelegate: class {
    func weatherViewModelDidFinish(_ viewModel: WeatherViewModel)
}

class WeatherViewModel {
    let cityName: String
    
    var weatherDegree: String = ""
    var weatherDescription: String = ""
    var humidity: String = ""
    var wind: String = ""
    var pressure: String = ""
    
    var imageName: String = ""
    var imageURL: URL?
    
    weak var delegate: WeatherViewModelDelegate?
    
    var weatherForecast: Weather?
    
    var onDidUpdate: (() -> Void)?
    var onDidError: ((Error) -> Void)?
    var onDidStartRequest: (() -> Void)?
    var onDidFinishRequest: (() -> Void)?
    
    private var apiService: NetworkingService
    
    let tempViewModel = TemperatureViewModel()
    let humidityViewModel = AdditionalViewModel()
    let windViewModel = AdditionalViewModel()
    let pressureViewModel = AdditionalViewModel()
    
    init(city: String, apiService: NetworkingService) {
        self.cityName = city
        self.apiService = apiService
    }
    
    func getWeather() {
        onDidStartRequest?()
        apiService.getWeatherByCity(city: cityName) { result in
            switch result {
            case .success(let weather):
                self.onDidFinishRequest?()
                self.weatherForecast = weather
                self.updateLabels()
                self.setupViewModels()
                self.onDidUpdate?()
            case .failure(let error):
                self.onDidFinishRequest?()
                self.onDidError?(error)
            }
        }
    }
    
    private func setupViewModels() {
        tempViewModel.update(temperature: self.weatherDegree,
                             weatherDescription: self.weatherDescription,
                             weatherImageUrl: self.imageURL!)
        
        humidityViewModel.update(itemName: R.string.weather.humiditY(),
                                 itemDescription: self.humidity)
        
        windViewModel.update(itemName: R.string.weather.winD(),
                             itemDescription: self.wind)
        
        pressureViewModel.update(itemName: R.string.weather.pressurE(),
                                 itemDescription: self.pressure)
    }
    
    private func updateLabels() {
        self.weatherDegree = String(Int((weatherForecast?.main.temp) ?? 0))
        self.weatherDescription = (weatherForecast?.weather.first?.main ?? "-") as String
        self.humidity = "\(Double((weatherForecast?.main.humidity) ?? 0)) %"
        let windDirection = (weatherForecast?.wind.deg.compassDirection ?? "") as String
        self.wind = "\(windDirection) \(Double((weatherForecast?.wind.speed) ?? 0)) m/s"
        self.pressure = "\(Int((weatherForecast?.main.pressure) ?? 0)) mm Hg"
        self.imageName = "a\((weatherForecast?.weather.first?.icon.dropLast() ?? "a01"))"
        self.imageURL = URL(string: Constants.apiImageUrl + (weatherForecast?.weather.first?.icon ?? "01n") + "@2x.png")
    }
    
    func goBack() {
        delegate?.weatherViewModelDidFinish(self)
    }
}
