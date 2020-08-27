//
//  WeatherViewController.swift
//  Practice2-Weather
//
//  Created by Кристина Перегудова on 16.08.2020.
//  Copyright © 2020 Кристина Перегудова. All rights reserved.
//

import UIKit
import SnapKit

class WeatherViewController: UIViewController {
    lazy var cityLabel = UILabel()
    lazy var tempLabel = UILabel()
    lazy var weatherLabel = UILabel()
    lazy var weatherImage = UIImageView()
    lazy var humidityLabel = UILabel()
    lazy var windLabel = UILabel()
    lazy var pressureLabel = UILabel()
    lazy var weatherImageLarge = UIImageView()
    
    lazy var humidity = UILabel()
    lazy var wind = UILabel()
    lazy var pressure = UILabel()
    
    private let viewModel: WeatherViewModel
    
    init(viewModel: WeatherViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.largeTitleDisplayMode = .never
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
}

extension WeatherViewController {
    private func initialSetup() {
        view.backgroundColor = .white
        viewModel.getWeather()
        bindToViewModel()
        setupLabels()
        setupLayout()
    }
    
    private func bindToViewModel() {
        viewModel.onDidUpdate = { [weak self] in
            guard let self = self else { return }
            let weatherForecast = self.viewModel.weatherForecast
            self.cityLabel.text = self.viewModel.cityName
            self.tempLabel.text = String(Int((weatherForecast?.main.temp) ?? 0))
            self.weatherLabel.text = weatherForecast?.weather.first?.description
            self.humidityLabel.text = "\(Double((weatherForecast?.main.humidity) ?? 0)) %"
            self.windLabel.text = "\(self.viewModel.compassDirection(for: weatherForecast?.wind.deg ?? -1)) \(Double((weatherForecast?.wind.speed) ?? 0)) m/s"
            self.pressureLabel.text = "\(Int((weatherForecast?.main.pressure) ?? 0)) mm Hg"
        }
    }
    
    private func setupLabels() {
        cityLabel.textColor = #colorLiteral(red: 0.2078431373, green: 0.2078431373, blue: 0.2078431373, alpha: 1)
        cityLabel.font = .boldSystemFont(ofSize: 34)
        
        tempLabel.textColor = #colorLiteral(red: 0.1137254902, green: 0.1176470588, blue: 0.1215686275, alpha: 1)
        tempLabel.font = .boldSystemFont(ofSize: 120)
        
        weatherLabel.textColor = #colorLiteral(red: 0.1137254902, green: 0.1176470588, blue: 0.1215686275, alpha: 1)
        weatherLabel.font = .systemFont(ofSize: 18)
        
        humidity.text = "HUMIDITY"
        humidity.textColor = #colorLiteral(red: 0.1137254902, green: 0.1176470588, blue: 0.1215686275, alpha: 1)
        humidity.font = .systemFont(ofSize: 18)
        
        humidityLabel.textColor = #colorLiteral(red: 0.1137254902, green: 0.1176470588, blue: 0.1215686275, alpha: 1)
        humidityLabel.font = .boldSystemFont(ofSize: 18)
        
        wind.text = "WIND"
        wind.textColor = #colorLiteral(red: 0.1137254902, green: 0.1176470588, blue: 0.1215686275, alpha: 1)
        wind.font = .systemFont(ofSize: 18)
        
        windLabel.textColor = #colorLiteral(red: 0.1137254902, green: 0.1176470588, blue: 0.1215686275, alpha: 1)
        windLabel.font = .boldSystemFont(ofSize: 18)
        
        pressure.text = "PRESSURE"
        pressure.textColor = #colorLiteral(red: 0.1137254902, green: 0.1176470588, blue: 0.1215686275, alpha: 1)
        pressure.font = .systemFont(ofSize: 18)
        
        pressureLabel.textColor = #colorLiteral(red: 0.1137254902, green: 0.1176470588, blue: 0.1215686275, alpha: 1)
        pressureLabel.font = .boldSystemFont(ofSize: 18)
    }
    
    private func setupLayout() {
        view.addSubview(cityLabel)
        cityLabel.snp.makeConstraints { make in
            make.top.equalTo(50)
            make.leading.equalTo(16)
        }
        
        view.addSubview(tempLabel)
        tempLabel.snp.makeConstraints { make in
            make.top.equalTo(cityLabel.snp.bottom).offset(24)
            make.leading.equalTo(15)
        }
        
        view.addSubview(weatherLabel)
        weatherLabel.snp.makeConstraints { make in
            make.top.equalTo(tempLabel.snp.bottom).offset(65)
            make.leading.equalTo(34)
        }
        
        view.addSubview(pressureLabel)
        pressureLabel.snp.makeConstraints { make in
            make.bottom.equalTo(-21)
            make.leading.equalTo(15)
        }
        
        view.addSubview(pressure)
        pressure.snp.makeConstraints { make in
            make.bottom.equalTo(pressureLabel.snp.top).offset(-10)
            make.leading.equalTo(16)
        }
        
        view.addSubview(windLabel)
        windLabel.snp.makeConstraints { make in
            make.bottom.equalTo(pressure.snp.top).offset(-40)
            make.leading.equalTo(15)
        }
        
        view.addSubview(wind)
        wind.snp.makeConstraints { make in
            make.bottom.equalTo(windLabel.snp.top).offset(-10)
            make.leading.equalTo(16)
        }
        
        view.addSubview(humidityLabel)
        humidityLabel.snp.makeConstraints { make in
            make.bottom.equalTo(wind.snp.top).offset(-40)
            make.leading.equalTo(15)
        }
        
        view.addSubview(humidity)
        humidity.snp.makeConstraints { make in
            make.bottom.equalTo(humidityLabel.snp.top).offset(-10)
            make.leading.equalTo(16)
        }
    }
    
    private func showError(_ error: String) {
        let alert = UIAlertController(title: "An error has occurred", message: error, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
}
