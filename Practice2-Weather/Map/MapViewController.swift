//
//  MapViewController.swift
//  Practice2-Weather
//
//  Created by Кристина Перегудова on 30.07.2020.
//  Copyright © 2020 Кристина Перегудова. All rights reserved.
//

import UIKit
import MapKit
import SnapKit
import SVProgressHUD

class MapViewController: UIViewController {
    private let viewModel: MapViewModel
    
    private let mapView = MKMapView()
    private let mapPickView = MapPickView()
    
    var timer: Timer?
    
    init(viewModel: MapViewModel) {
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

extension MapViewController {
    private func initialSetup() {
        view.backgroundColor = .white
        setupNavigationBar()
        setupMapView()
        configureMapPickView()
        setupMapPickView(bottomConstraintOffset: 170)
        bindToViewModel()
    }
    
    private func bindToViewModel() {
        viewModel.onDidUpdate = { [weak self] in
            guard let self = self else { return }
            self.updateViews()
        }
        
        viewModel.onDidError = { error in
            self.showError(error)
        }
        
        viewModel.onDidStartRequest = { [unowned self] in
            SVProgressHUD.show()
        }
        
        viewModel.onDidFinishRequest = { [unowned self] in
            SVProgressHUD.dismiss()
        }
    }
    
    private func  updateViews() {
        guard let cityName = self.viewModel.selectedCity else {
            self.mapView.removeAnnotations(self.mapView.annotations)
            self.changeMapPickView(isOpen: false)
            return
        }
        self.mapPickView.coordinateLabel.text = self.viewModel.selectedCoordinate?.dms
        self.mapPickView.cityLabel.text = cityName
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = self.viewModel.selectedCoordinate!
        self.mapView.removeAnnotations(self.mapView.annotations)
        self.mapView.addAnnotation(annotation)
        self.mapView.setCenter(self.viewModel.selectedCoordinate!, animated: true)
        
        self.changeMapPickView(isOpen: true)
    }
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.barTintColor = UIColor.white
        navigationItem.title = R.string.map.navBarTitle()
        navigationItem.backBarButtonItem = UIBarButtonItem(title: R.string.weather.backButtonTitle(),
                                                           style: .plain,
                                                           target: nil,
                                                           action: nil)
        
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
        
        self.navigationController?.navigationBar.layer.setStandartShadow()
    }
    
    private func setupMapView() {
        view.addSubview(mapView)
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(mapTapRecognizer))
        gestureRecognizer.delegate = self
        mapView.addGestureRecognizer(gestureRecognizer)
        mapView.setCenter(self.viewModel.startCoordinate, animated: true)
        mapView.mapType = .mutedStandard
        
        mapView.snp.makeConstraints { make in
            make.top.equalTo(view.snp.topMargin)
            make.trailing.equalTo(view.snp.trailing)
            make.leading.equalTo(view.snp.leading)
            make.bottom.equalTo(view.snp.bottom)
        }
    }
    
    private func configureMapPickView() {
        mapPickView.setup(with: viewModel.mapPickViewModel!)
        view.addSubview(mapPickView)
    }
    
    private func setupMapPickView(bottomConstraintOffset: Int) {
        mapPickView.snp.remakeConstraints { make in
            make.trailing.equalTo(view.snp.trailing).offset(-16)
            make.leading.equalTo(view.snp.leading).offset(16)
            make.bottom.equalTo(view.snp.bottom).offset(bottomConstraintOffset)
        }
    }
}

extension MapViewController: UIGestureRecognizerDelegate {
    @objc func mapTapRecognizer(sender: UIGestureRecognizer) {
        
        let location = sender.location(in: mapView)
        let coordinate = mapView.convert(location, toCoordinateFrom: mapView)
        
        viewModel.selectedCoordinate = coordinate
        viewModel.geocodeCityFromCoordinate(coordinate: coordinate)
    }
}

extension MapViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        guard !text.isEmpty else { return }
        
        self.viewModel.geocodeCoordinateFromCity(city: text)
    }
}

extension MapViewController {
    private func changeMapPickView(isOpen: Bool) {
        if isOpen {
            self.setupMapPickView(bottomConstraintOffset: -16)
        } else {
            self.setupMapPickView(bottomConstraintOffset: 170)
        }
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
}
