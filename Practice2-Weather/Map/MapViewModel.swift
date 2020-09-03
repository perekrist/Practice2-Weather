//
//  MapViewModel.swift
//  Practice2-Weather
//
//  Created by Кристина Перегудова on 30.07.2020.
//  Copyright © 2020 Кристина Перегудова. All rights reserved.
//

import UIKit
import MapKit

protocol MapViewModelDelegate: class {
    func mapViewModel(_ viewModel: MapViewModel, didRequestShowWeatherFor city: String)
}

class MapViewModel {
    weak var delegate: MapViewModelDelegate?
    
    let startCoordinate = Constants.startCoordinates
    
    var selectedCity: String?
    var selectedCoordinate: CLLocationCoordinate2D?
    var mapPickViewModel: MapPickViewModel?
    
    var onDidUpdate: (() -> Void)?
    var onDidError: ((Error) -> Void)?
    
    var onDidStartRequest: (() -> Void)?
    var onDidFinishRequest: (() -> Void)?
    
    private var geoCodingService = GeoCodingService()
    private var searchItem: DispatchWorkItem?
    
    init() {
        mapPickViewModel = MapPickViewModel(delegate: self)
    }
    
    func geocodeCityFromCoordinate(coordinate: CLLocationCoordinate2D) {
        onDidStartRequest?()
        geoCodingService.cityFromCoordinates(coordinate: coordinate) { result in
            switch result {
            case .success(let placemark):
                self.onDidFinishRequest?()
                self.selectedCity = placemark?.locality
                self.selectedCoordinate = placemark?.location?.coordinate
                self.onDidUpdate?()
            case .failure(let error):
                self.onDidFinishRequest?()
                self.onDidError?(error)
            }
        }
    }
    
    func geocodeCoordinateFromCity(city: String) {
        searchItem?.cancel()
        searchItem = DispatchWorkItem { [weak self] in
            guard let self = self else { return }
            self.onDidStartRequest?()
            self.geoCodingService.coordinatesFromCity(city: city) { result in
                switch result {
                case .success(let placemark):
                    self.onDidFinishRequest?()
                    self.selectedCity = placemark?.locality
                    self.selectedCoordinate = placemark?.location?.coordinate
                    self.onDidUpdate?()
                case .failure(let error):
                    self.onDidFinishRequest?()
                    self.onDidError?(error)
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
