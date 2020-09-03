//
//  CompassDirectionFormatter.swift
//  Practice2-Weather
//
//  Created by Кристина Перегудова on 02.09.2020.
//  Copyright © 2020 Кристина Перегудова. All rights reserved.
//

import Foundation

extension Double {
    var compassDirection: String {
        if self < 0 { return "" }
        let directions = ["N", "NE", "E", "SE", "S", "SW", "W", "NW"]
        let index = Int((self + 22.5) / 45.0) & 7
        return directions[index]
    }
}
