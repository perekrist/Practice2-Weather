//
//  TemperatureView.swift
//  Practice2-Weather
//
//  Created by Кристина Перегудова on 03.09.2020.
//  Copyright © 2020 Кристина Перегудова. All rights reserved.
//

import UIKit
import SnapKit
import Kingfisher

class TemperatureView: UIView {
    var viewModel: TemperatureViewModel?
    
    lazy var tempLabel = UILabel()
    lazy var weatherLabel = UILabel()
    lazy var weatherImage = UIImageView()
    var celsius = UILabel()
    
    override func didMoveToSuperview() {
        setupLabels()
        setupLayout()
    }
}

extension TemperatureView {
    func setup(with viewModel: TemperatureViewModel) {
        self.viewModel = viewModel
        
        print(viewModel.temp)
        
        update()
        setNeedsLayout()
    }
    
    func update() {
        self.tempLabel.text = self.viewModel?.temp
        self.weatherLabel.text = self.viewModel?.weatherDescription
        self.weatherImage.kf.setImage(with: self.viewModel?.imageURL)
    }
    
    private func setupLayout() {
        self.addSubview(tempLabel)
        tempLabel.snp.makeConstraints { make in
            make.top.equalTo(self.snp.top)
            make.leading.equalTo(15)
        }
        
        self.addSubview(celsius)
        celsius.snp.makeConstraints { make in
            make.top.equalTo(tempLabel.snp.top).offset(15)
            make.leading.equalTo(tempLabel.snp.trailing)
        }
        
        self.addSubview(weatherImage)
        weatherImage.snp.makeConstraints { make in
            make.top.equalTo(tempLabel.snp.bottom)
            make.leading.equalTo(17)
            make.height.equalTo(87)
        }
        weatherImage.contentMode = .scaleAspectFit
        
        self.addSubview(weatherLabel)
        weatherLabel.snp.makeConstraints { make in
            make.top.equalTo(weatherImage.snp.bottom).offset(12)
            make.leading.equalTo(34)
        }
    }
    
    private func setupLabels() {
        tempLabel.textColor = #colorLiteral(red: 0.1137254902, green: 0.1176470588, blue: 0.1215686275, alpha: 1)
        tempLabel.font = .boldSystemFont(ofSize: 120)
        
        celsius.textColor = #colorLiteral(red: 0.1137254902, green: 0.1176470588, blue: 0.1215686275, alpha: 1)
        celsius.text = R.string.weather.celsius()
        celsius.font = .systemFont(ofSize: 50)
        
        weatherLabel.textColor = #colorLiteral(red: 0.1137254902, green: 0.1176470588, blue: 0.1215686275, alpha: 1)
        weatherLabel.font = .systemFont(ofSize: 18)
    }
}
