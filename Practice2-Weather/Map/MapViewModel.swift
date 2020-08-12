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
    
    var error = ""
    
    var onDidUpdate: (() -> Void)?
    var onDidError: (() -> Void)?
    
    func geocodeCityFromCoordinate(coordinate: CLLocationCoordinate2D) {
        SVProgressHUD.show()
        cityFromCoordinates(coordinate: coordinate) { result in
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
        coordinatesFromCity(city: city) { result in
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

extension MapViewModel: MapPickViewModelDelegate {
    func mapPickViewModelDidTapClose(_ viewModel: MapPickViewModel) {
        viewModel.isOpened = false
        self.onDidUpdate?()
    }
    
    func mapPickViewModellDidTapShowWeather(_ viewModel: MapPickViewModel) {
        viewModel.isOpened = false
        self.onDidUpdate?()
    }
}
