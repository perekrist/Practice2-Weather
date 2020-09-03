//
//  Weather.swift
//  Practice2-Weather
//
//  Created by Кристина Перегудова on 21.08.2020.
//  Copyright © 2020 Кристина Перегудова. All rights reserved.
//

import Foundation

struct Weather: Codable {
    let weather: [WeatherForecast]
    let main: WeatherMain
    let wind: WeatherWind
}

struct WeatherForecast: Codable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}

struct WeatherMain: Codable {
    let temp: Double
    let pressure: Double
    let humidity: Double
}

struct WeatherWind: Codable {
    let speed: Double
    let deg: Double
}
