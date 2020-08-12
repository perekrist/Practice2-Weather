//
//  MapViewModel.swift
//  Practice2-Weather
//
//  Created by Кристина Перегудова on 30.07.2020.
//  Copyright © 2020 Кристина Перегудова. All rights reserved.
//

import UIKit
import MapKit
import SVProgressHUD

class MapViewModel {
    
    var selectedCity: String? = nil
    var selectedCoordinate: CLLocationCoordinate2D? = nil
    var geoCodingService = GeoCodingService()
    
    var error = ""
    
    var onDidUpdate: (() -> Void)?
    var onDidError: (() -> Void)?
    
    func geocodeCityFromCoordinate(coordinate: CLLocationCoordinate2D) {
        SVProgressHUD.show()
        geoCodingService.cityFromCoordinates(coordinate: coordinate) { result in
            switch result {
            case .success(let placemark):
                SVProgressHUD.dismiss()
                self.selectedCity = placemark?.locality
                self.selectedCoordinate = placemark?.location?.coordinate
                self.onDidUpdate?()
            case .failure(let error):
                SVProgressHUD.dismiss()
                print("errrror: " + error.localizedDescription)
                self.error = error.localizedDescription
                self.selectedCity = nil
            }
        }
    }
    
    func geocodeCoordinateFromCity(city: String) {
        SVProgressHUD.show()
        geoCodingService.coordinatesFromCity(city: city) { result in
            switch result {
            case .success(let placemark):
                SVProgressHUD.dismiss()
                self.selectedCity = placemark?.locality
                self.selectedCoordinate = placemark?.location?.coordinate
                self.onDidUpdate?()
            case .failure(let error):
                SVProgressHUD.dismiss()
                print("errrror: " + error.localizedDescription)
                self.error = error.localizedDescription
                self.selectedCoordinate = nil
            }
        }
    }
}
