//
//  MapPickView.swift
//  Practice2-Weather
//
//  Created by Кристина Перегудова on 30.07.2020.
//  Copyright © 2020 Кристина Перегудова. All rights reserved.
//

import UIKit
import SnapKit

class MapPickView: UIView {
    
    var viewModel: MapPickViewModel?
    
    private lazy var cityLabel = UILabel()
    private lazy var coordinateLabel = UILabel()
    private lazy var closeButton = UIButton(type: .system)
    private lazy var showWeatherButton = UIButton(type: .system)
    
    override func didMoveToSuperview() {
        setupLabels()
        setupButtons()
        setupLayout()
    }
}

extension MapPickView {
    
    func setup(with viewModel: MapPickViewModel) {
        self.viewModel = viewModel
        
        self.cityLabel.text = self.viewModel?.city
        self.coordinateLabel.text = self.viewModel?.coordinate
        
        setNeedsLayout()
    }
    
    private func setupLayout() {
        cityLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.snp.top).offset(16)
            make.leading.equalTo(self.snp.leading).offset(16)
        }
        
        closeButton.snp.makeConstraints { (make) in
            make.top.equalTo(self.snp.top).offset(20)
            make.trailing.equalTo(self.snp.trailing).offset(20)
            make.width.height.equalTo(12)
        }
        
        coordinateLabel.snp.makeConstraints { (make) in
            make.top.equalTo(cityLabel.snp.bottom).offset(2)
            make.leading.equalTo(self.snp.leading).offset(16)
        }
        
        showWeatherButton.snp.makeConstraints { (make) in
            make.top.equalTo(coordinateLabel.snp.bottom).offset(37)
            make.leading.equalTo(self.snp.leading).offset(16)
            make.bottom.equalTo(self.snp.bottom).offset(13)
        }
        
        self.layer.cornerRadius = 5
        self.layer.shadowRadius = 5
    }
    
    private func setupLabels() {
        cityLabel.font = .systemFont(ofSize: 20)
        cityLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        
        coordinateLabel.font = .systemFont(ofSize: 15)
        coordinateLabel.textColor = #colorLiteral(red: 0.6744518876, green: 0.6745483279, blue: 0.6744211912, alpha: 1)
    }
    
    private func setupButtons() {
        closeButton.tintColor = #colorLiteral(red: 0.1564054489, green: 0.5728738904, blue: 0.9122014046, alpha: 1)
        closeButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        closeButton.addTarget(self, action: #selector(closeMapPickView), for: .touchUpInside)
        
        showWeatherButton.setTitle("Show Weather", for: .normal)
        showWeatherButton.tintColor = #colorLiteral(red: 0.1564054489, green: 0.5728738904, blue: 0.9122014046, alpha: 1)
        showWeatherButton.titleLabel?.font = closeButton.titleLabel?.font.withSize(16)
        showWeatherButton.layer.cornerRadius = 5
        showWeatherButton.layer.borderWidth = 1
        showWeatherButton.layer.borderColor = #colorLiteral(red: 0.2901960784, green: 0.5647058824, blue: 0.8862745098, alpha: 1)
        showWeatherButton.addTarget(self, action: #selector(showWeather), for: .touchUpInside)
    }
    
    @objc private func closeMapPickView() {
        
    }
    
    @objc private func showWeather() {
        
    }
}
