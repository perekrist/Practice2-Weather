//
//  CoordinateToDMS.swift
//  Practice2-Weather
//
//  Created by Кристина Перегудова on 31.07.2020.
//  Copyright © 2020 Кристина Перегудова. All rights reserved.
//

import Foundation
import MapKit

extension FloatingPoint {
    var minutes: Self {
        return (self * 3600)
            .truncatingRemainder(dividingBy: 3600) / 60
    }
    var seconds: Self {
        return (self * 3600)
            .truncatingRemainder(dividingBy: 3600)
            .truncatingRemainder(dividingBy: 60)
    }
}

extension CLLocationCoordinate2D {
    var dms: String {
        return (String(format: "%d°%d'%.1f\"%@ %d°%d'%.1f\"%@",
                       Int(abs(latitude)),
                       Int(abs(latitude.minutes)),
                       abs(latitude.seconds),
                       latitude >= 0 ? "N" : "S",
                       Int(abs(longitude)),
                       Int(abs(longitude.minutes)),
                       abs(longitude.seconds),
                       longitude >= 0 ? "E" : "W"))
    }
}
