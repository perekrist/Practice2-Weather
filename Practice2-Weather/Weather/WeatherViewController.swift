//
//  WeatherViewController.swift
//  Practice2-Weather
//
//  Created by Кристина Перегудова on 16.08.2020.
//  Copyright © 2020 Кристина Перегудова. All rights reserved.
//

import UIKit
import SnapKit
import Kingfisher

class WeatherViewController: UIViewController {
    lazy var cityLabel = UILabel()
    
    private let viewModel: WeatherViewModel
    private let tempViewModel = TemperatureViewModel()
    
    private lazy var humidityLabel = UILabel()
    private lazy var windLabel = UILabel()
    private lazy var pressureLabel = UILabel()
    
    private lazy var weatherImageLarge = UIImageView()
    
    private lazy var temperatureView = TemperatureView()
    
    private var humidity = UILabel()
    private var wind = UILabel()
    private var pressure = UILabel()
    
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
        setupLabels()
        setupImages()
        addConstraints()
        bindToViewModel()
        viewModel.getWeather()
    }
    
    private func bindToViewModel() {
        viewModel.onDidUpdate = { [weak self] in
            guard let self = self else { return }
            self.updateTempView()
            self.updateLabels()
            self.updateImages()
        }
        
        viewModel.onDidError = { [weak self] error in
            guard let self = self else { return }
            self.showError(error)
        }
    }
    
    private func updateTempView() {
        self.tempViewModel.update(temperature: self.viewModel.weatherDegree,
                                  weatherDescription: self.viewModel.weatherDescription,
                                  weatherImageUrl: self.viewModel.imageURL!)
        self.temperatureView.update()
    }
    
    private func updateLabels() {
        self.cityLabel.text = self.viewModel.cityName
        
        self.humidityLabel.text = self.viewModel.humidity
        self.windLabel.text = self.viewModel.wind
        self.pressureLabel.text = self.viewModel.pressure
    }
    
    private func updateImages() {
        self.setupImageView(self.viewModel.imageName)
    }
    
    private func setupLabels() {
        setupMainLabels()
        setupAdditionalLabels()
    }
    
    private func setupMainLabels() {
        cityLabel.textColor = #colorLiteral(red: 0.2078431373, green: 0.2078431373, blue: 0.2078431373, alpha: 1)
        cityLabel.font = .boldSystemFont(ofSize: 34)
    }
    
    private func setupAdditionalLabels() {
        humidity.text = R.string.weather.humiditY()
        humidity.textColor = #colorLiteral(red: 0.1137254902, green: 0.1176470588, blue: 0.1215686275, alpha: 1)
        humidity.font = .systemFont(ofSize: 18)
        
        humidityLabel.textColor = #colorLiteral(red: 0.1137254902, green: 0.1176470588, blue: 0.1215686275, alpha: 1)
        humidityLabel.font = .boldSystemFont(ofSize: 18)
        
        wind.text = R.string.weather.winD()
        wind.textColor = #colorLiteral(red: 0.1137254902, green: 0.1176470588, blue: 0.1215686275, alpha: 1)
        wind.font = .systemFont(ofSize: 18)
        
        windLabel.textColor = #colorLiteral(red: 0.1137254902, green: 0.1176470588, blue: 0.1215686275, alpha: 1)
        windLabel.font = .boldSystemFont(ofSize: 18)
        
        pressure.text = R.string.weather.pressurE()
        pressure.textColor = #colorLiteral(red: 0.1137254902, green: 0.1176470588, blue: 0.1215686275, alpha: 1)
        pressure.font = .systemFont(ofSize: 18)
        
        pressureLabel.textColor = #colorLiteral(red: 0.1137254902, green: 0.1176470588, blue: 0.1215686275, alpha: 1)
        pressureLabel.font = .boldSystemFont(ofSize: 18)
    }
    
    private func setupImages() {
        weatherImageLarge.contentMode = .scaleAspectFit
    }
    
    private func addConstraints() {
        constraintMainInfo()
        constraintAdditionalInfo()
    }
    
    private func constraintMainInfo() {
        view.addSubview(cityLabel)
        cityLabel.snp.makeConstraints { make in
            make.top.equalTo(90)
            make.leading.equalTo(16)
        }
        
        temperatureView.setup(with: tempViewModel)
        view.addSubview(temperatureView)
        temperatureView.snp.makeConstraints { make in
            make.top.equalTo(cityLabel.snp.bottom)
            make.leading.equalTo(16)
        }
    }
    
    private func constraintAdditionalInfo() {
        view.addSubview(pressureLabel)
        pressureLabel.snp.makeConstraints { make in
            make.bottom.equalTo(-21)
            make.leading.equalTo(15)
        }
        
        view.addSubview(pressure)
        pressure.snp.makeConstraints { make in
            make.bottom.equalTo(pressureLabel.snp.top).offset(-7)
            make.leading.equalTo(16)
        }
        
        view.addSubview(windLabel)
        windLabel.snp.makeConstraints { make in
            make.bottom.equalTo(pressure.snp.top).offset(-20)
            make.leading.equalTo(15)
        }
        
        view.addSubview(wind)
        wind.snp.makeConstraints { make in
            make.bottom.equalTo(windLabel.snp.top).offset(-7)
            make.leading.equalTo(16)
        }
        
        view.addSubview(humidityLabel)
        humidityLabel.snp.makeConstraints { make in
            make.bottom.equalTo(wind.snp.top).offset(-20)
            make.leading.equalTo(15)
        }
        
        view.addSubview(humidity)
        humidity.snp.makeConstraints { make in
            make.bottom.equalTo(humidityLabel.snp.top).offset(-7)
            make.leading.equalTo(16)
        }
        
        view.addSubview(weatherImageLarge)
        weatherImageLarge.snp.makeConstraints { make in
            make.trailing.equalTo(0)
            make.bottom.equalTo(0)
        }
    }
    
    private func setupImageView(_ imageName: String) {
        self.weatherImageLarge.image = R.image.clearSky()
        guard let image = UIImage(named: imageName.replacingOccurrences(of: " ", with: "-")) else { return }
        weatherImageLarge.image = image
    }
}
