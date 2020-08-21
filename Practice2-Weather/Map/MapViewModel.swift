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

protocol MapViewModelDelegate: class {
    func mapViewModel(_ viewModel: MapViewModel, didRequestShowWeatherFor city: String)
}

class MapViewModel {
    weak var delegate: MapViewModelDelegate?
    
    var selectedCity: String?
    var selectedCoordinate: CLLocationCoordinate2D?
    var geoCodingService = GeoCodingService()
    
    var error = ""
    
    var onDidUpdate: (() -> Void)?
    var onDidError: (() -> Void)?
    
    var mapPickViewIsOpened = false
    
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
    
    private func goToWeather() {
        delegate?.mapViewModel(self, didRequestShowWeatherFor: selectedCity!)
    }
}

extension MapViewModel: MapPickViewModelDelegate {
    func mapPickViewModelDidTapClose(_ viewModel: MapPickViewModel) {
        self.mapPickViewIsOpened = false
    }
    
    func mapPickViewModellDidTapShowWeather(_ viewModel: MapPickViewModel) {
        goToWeather()
    }
}
