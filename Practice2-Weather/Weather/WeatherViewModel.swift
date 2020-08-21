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
        
    var apiService: ApiNetworkingService?
    
    var onDidUpdate: (() -> Void)?
    
    init(city: String) {
        self.cityName = city
        apiService = ApiNetworkingService()
    }
    
    func getWeather() {
        SVProgressHUD.show()
        apiService!.getWeatherByCity(city: cityName) { result in
            switch result {
            case .success(let weather):
                SVProgressHUD.dismiss()
                print(weather)
            case .failure(let error):
                SVProgressHUD.dismiss()
                print(error)
            }
        }
    }
}
