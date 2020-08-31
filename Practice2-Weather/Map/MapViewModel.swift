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
    
    let startCoordinate = Constants.startCoordinates    
    private var searchItem: DispatchWorkItem?
    
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
                self.error = error.localizedDescription
                self.onDidError?()
            }
        }
    }
    
    func geocodeCoordinateFromCity(city: String) {
        searchItem?.cancel()
        searchItem = DispatchWorkItem { [weak self] in
            guard let self = self else { return }
            SVProgressHUD.show()
            self.geoCodingService.coordinatesFromCity(city: city) { result in
                switch result {
                case .success(let placemark):
                    SVProgressHUD.dismiss()
                    self.selectedCity = placemark?.locality
                    self.selectedCoordinate = placemark?.location?.coordinate
                    self.onDidUpdate?()
                case .failure(let error):
                    SVProgressHUD.dismiss()
                    self.error = error.localizedDescription
                    self.onDidError?()
                }
            }
        }
        if let searchTask = searchItem {
          DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: searchTask)
        }
    }
    
    private func goToWeather() {
        delegate?.mapViewModel(self, didRequestShowWeatherFor: selectedCity!)
    }
}

extension MapViewModel: MapPickViewModelDelegate {
    func mapPickViewModelDidTapClose(_ viewModel: MapPickViewModel) {
        self.selectedCoordinate = nil
        self.selectedCity = nil
        self.onDidUpdate?()
    }
    
    func mapPickViewModellDidTapShowWeather(_ viewModel: MapPickViewModel) {
        goToWeather()
    }
}
