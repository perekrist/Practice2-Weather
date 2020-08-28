//
//  GeoCodingService.swift
//  Practice2-Weather
//
//  Created by Кристина Перегудова on 12.08.2020.
//  Copyright © 2020 Кристина Перегудова. All rights reserved.
//

import Foundation
import MapKit

class GeoCodingService {
    func cityFromCoordinates(coordinate: CLLocationCoordinate2D, completion: @escaping (Result<CLPlacemark?, Error>) -> Void) {
        CLGeocoder()
            .reverseGeocodeLocation(CLLocation(latitude: coordinate.latitude,
                                               longitude: coordinate.longitude)) { placemarks, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                completion(.success(placemarks?.first))
        }
    }
    
    func coordinatesFromCity(city: String, completion: @escaping (Result<CLPlacemark?, Error>) -> Void) {
        CLGeocoder()
            .geocodeAddressString(city) { placemarks, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                completion(.success(placemarks?.first))
        }
    }
}
