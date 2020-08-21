//
//  Weather.swift
//  Practice2-Weather
//
//  Created by Кристина Перегудова on 21.08.2020.
//  Copyright © 2020 Кристина Перегудова. All rights reserved.
//

import Foundation

struct Weather: Codable {
    let info: [WeatherInfo]?
    let details: WeatherDetails?
    let wind: WeatherWind?
}

struct WeatherInfo: Codable {
    let id: Int?
    let description: String?
    let icon: String?
}

struct WeatherDetails: Codable {
    let temperature: Double?
    let pressure: Double?
    let humidity: Double?
}

struct WeatherWind: Codable {
    let speed: Double?
    let direction: Double?
}

