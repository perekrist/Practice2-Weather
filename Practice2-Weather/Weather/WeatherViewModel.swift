//
//  WeatherViewModel.swift
//  Practice2-Weather
//
//  Created by Кристина Перегудова on 16.08.2020.
//  Copyright © 2020 Кристина Перегудова. All rights reserved.
//

import UIKit

class WeatherViewModel {
    var error = ""
    
    var onDidUpdate: (() -> Void)?
    var onDidError: (() -> Void)?
    
}
