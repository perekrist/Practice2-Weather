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
import SVProgressHUD

class WeatherViewController: UIViewController {
    private let viewModel: WeatherViewModel
    
    private lazy var weatherImageLarge = UIImageView()
    private lazy var cityLabel = UILabel()
    private lazy var temperatureView = TemperatureView()
    private lazy var humidityView = AdditionalView()
    private lazy var windView = AdditionalView()
    private lazy var pressureView = AdditionalView()
    
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
            self.updateAdditionalViews()
            self.updateLabels()
            self.updateImages()
        }
        
        viewModel.onDidError = { [weak self] error in
            guard let self = self else { return }
            self.showError(error)
        }
        
        viewModel.onDidStartRequest = { [unowned self] in
            SVProgressHUD.show()
        }
        
        viewModel.onDidFinishRequest = { [unowned self] in
            SVProgressHUD.dismiss()
        }
    }
    
    private func updateTempView() {
        self.temperatureView.update()
    }
    
    private func updateAdditionalViews() {
        self.humidityView.update()
        self.windView.update()
        self.pressureView.update()
    }
    
    private func updateLabels() {
        self.cityLabel.text = self.viewModel.cityName
    }
    
    private func updateImages() {
        self.setupImageView(self.viewModel.imageName)
    }
    
    private func setupLabels() {
        cityLabel.textColor = #colorLiteral(red: 0.2078431373, green: 0.2078431373, blue: 0.2078431373, alpha: 1)
        cityLabel.font = .boldSystemFont(ofSize: 34)
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
        
        temperatureView.setup(with: viewModel.tempViewModel)
        view.addSubview(temperatureView)
        temperatureView.snp.makeConstraints { make in
            make.top.equalTo(cityLabel.snp.bottom)
            make.leading.equalTo(16)
        }
    }
    
    private func constraintAdditionalInfo() {
        view.addSubview(weatherImageLarge)
        weatherImageLarge.snp.makeConstraints { make in
            make.trailing.equalTo(0)
            make.bottom.equalTo(0)
        }
        
        pressureView.setup(with: viewModel.pressureViewModel)
        view.addSubview(pressureView)
        pressureView.snp.makeConstraints { make in
            make.bottom.equalTo(view.snp.bottom).offset(-40)
            make.leading.equalTo(16)
        }
        
        windView.setup(with: viewModel.windViewModel)
        view.addSubview(windView)
        windView.snp.makeConstraints { make in
            make.bottom.equalTo(pressureView.snp.top).offset(-60)
            make.leading.equalTo(16)
        }
        
        humidityView.setup(with: viewModel.humidityViewModel)
        view.addSubview(humidityView)
        humidityView.snp.makeConstraints { make in
            make.bottom.equalTo(windView.snp.top).offset(-60)
            make.leading.equalTo(16)
        }
    }
    
    private func setupImageView(_ imageName: String) {
        self.weatherImageLarge.image = R.image.a01()
        guard let image = UIImage(named: imageName.replacingOccurrences(of: " ", with: "-")) else { return }
        weatherImageLarge.image = image
    }
}
