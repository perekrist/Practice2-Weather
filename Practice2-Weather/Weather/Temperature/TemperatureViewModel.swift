//
//  TemperatureViewModel.swift
//  Practice2-Weather
//
//  Created by Кристина Перегудова on 03.09.2020.
//  Copyright © 2020 Кристина Перегудова. All rights reserved.
//

import Foundation

class TemperatureViewModel {
    var temp: String?
    var weatherDescription: String?
    var imageURL: URL?
    
    func update(temperature: String, weatherDescription: String, weatherImageUrl: URL) {
        self.temp = temperature
        self.weatherDescription = weatherDescription
        self.imageURL = weatherImageUrl
    }
}
