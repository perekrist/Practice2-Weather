//
//  MapPickViewModel.swift
//  Practice2-Weather
//
//  Created by Кристина Перегудова on 30.07.2020.
//  Copyright © 2020 Кристина Перегудова. All rights reserved.
//

import Foundation

protocol MapPickViewModelDelegate: class {
    func mapPickViewModelDidTapClose(_ viewModel: MapPickViewModel)
    func mapPickViewModellDidTapShowWeather(_ viewModel: MapPickViewModel)
}

class MapPickViewModel {
    
    weak var delegate: MapPickViewModelDelegate?
    
    var city: String?
    var coordinate: String?
    var isOpened = false
        
    init(delegate: MapPickViewModelDelegate) {
        self.delegate = delegate
    }
    
    func onCloseButton() {
        delegate?.mapPickViewModelDidTapClose(self)
    }
    
    func onShowWeatherButton() {
        delegate?.mapPickViewModellDidTapShowWeather(self)
    }
}
