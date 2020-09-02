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
    lazy var tempLabel = UILabel()
    lazy var weatherLabel = UILabel()
    lazy var weatherImage = UIImageView()
    lazy var humidityLabel = UILabel()
    lazy var windLabel = UILabel()
    lazy var pressureLabel = UILabel()
    lazy var weatherImageLarge = UIImageView()
    lazy var celsius = UILabel()
    
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
        setupImages()
        setupLayout()
    }
    
    private func bindToViewModel() {
        viewModel.onDidUpdate = { [weak self] in
            guard let self = self else { return }
            self.cityLabel.text = self.viewModel.cityName
            self.tempLabel.text = self.viewModel.weatherDegree
            self.weatherLabel.text = self.viewModel.weatherDescription
            self.humidityLabel.text = self.viewModel.humidity
            self.windLabel.text = self.viewModel.wind
            self.pressureLabel.text = self.viewModel.pressure
            
            self.setupImageView(self.viewModel.imageName)
            self.weatherImage.kf.setImage(with: self.viewModel.imageURL)
        }
        
        viewModel.onDidError = { [weak self] error in
            guard let self = self else { return }
            self.showError(error)
        }
    }
    
    private func setupLabels() {
        cityLabel.textColor = #colorLiteral(red: 0.2078431373, green: 0.2078431373, blue: 0.2078431373, alpha: 1)
        cityLabel.font = .boldSystemFont(ofSize: 34)
        
        tempLabel.textColor = #colorLiteral(red: 0.1137254902, green: 0.1176470588, blue: 0.1215686275, alpha: 1)
        tempLabel.font = .boldSystemFont(ofSize: 120)
        
        celsius.textColor = #colorLiteral(red: 0.1137254902, green: 0.1176470588, blue: 0.1215686275, alpha: 1)
        celsius.text = R.string.weather.celsius()
        celsius.font = .systemFont(ofSize: 50)
        
        weatherLabel.textColor = #colorLiteral(red: 0.1137254902, green: 0.1176470588, blue: 0.1215686275, alpha: 1)
        weatherLabel.font = .systemFont(ofSize: 18)
        
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
        weatherImage.contentMode = .scaleAspectFit
        weatherImageLarge.contentMode = .scaleAspectFit
    }
    
    private func setupLayout() {
        view.addSubview(cityLabel)
        cityLabel.snp.makeConstraints { make in
            make.top.equalTo(100)
            make.leading.equalTo(16)
        }
        
        view.addSubview(tempLabel)
        tempLabel.snp.makeConstraints { make in
            make.top.equalTo(cityLabel.snp.bottom).offset(24)
            make.leading.equalTo(15)
        }
        
        view.addSubview(celsius)
        celsius.snp.makeConstraints { make in
            make.top.equalTo(tempLabel.snp.top).offset(15)
            make.leading.equalTo(tempLabel.snp.trailing)
        }
        
        view.addSubview(weatherImage)
        weatherImage.snp.makeConstraints { make in
            make.top.equalTo(tempLabel.snp.bottom).offset(10)
            make.leading.equalTo(17)
            make.height.equalTo(87)
        }
        
        view.addSubview(weatherLabel)
        weatherLabel.snp.makeConstraints { make in
            make.top.equalTo(weatherImage.snp.bottom).offset(12)
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
    
    private func showError(_ error: String) {
        let alert = UIAlertController(title: R.string.common.errorTitle(), message: error, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: R.string.common.okTitle(), style: .cancel) { _ in
          self.navigationController?.popViewController(animated: true)
          self.viewModel.goBack()
        })
        self.present(alert, animated: true, completion: nil)
    }
    
}
