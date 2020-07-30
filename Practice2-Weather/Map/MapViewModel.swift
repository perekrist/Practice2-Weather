//
//  MapViewModel.swift
//  Practice2-Weather
//
//  Created by Кристина Перегудова on 30.07.2020.
//  Copyright © 2020 Кристина Перегудова. All rights reserved.
//

import UIKit
import MapKit

class MapViewModel {
    
    var selectedCity: String? = nil
    var selectedCoordinate: CLLocationCoordinate2D? = nil

    
    
    func geocodeCityFromCoordinate(coordinate: CLLocationCoordinate2D) {
        cityFromCoordinates(coordinate: coordinate) { result in
            switch result {
            case .success(let placemark):
                self.selectedCity = placemark?.locality
                print(String(self.selectedCity!))
            case .failure(let error):
                print(error)
                self.selectedCity = nil
            }
        }
    }
    
    func geocodeCoordinateFromCity(city: String) {
        coordinatesFromCity(city: city) { result in
            switch result {
            case .success(let placemark):
                self.selectedCity = placemark?.locality
                self.selectedCoordinate = placemark?.location?.coordinate
                print(String(self.selectedCity ?? "hi"))
            case .failure(let error):
                print(error)
                self.selectedCoordinate = nil
            }
        }
    }
}

extension MapViewModel {
    func cityFromCoordinates(coordinate: CLLocationCoordinate2D, completion: @escaping (Result<CLPlacemark?, Error>) -> Void) {
        CLGeocoder()
            .reverseGeocodeLocation(CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)) { placemarks, error in
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
